require 'test_helper'
require_relative 'test_helper'

class VacationRequest::OperationTest < ActiveSupport::TestCase

  include VacationRequestTestHelper

  setup do
    @employee = create_employee
  end

  context 'as employee' do
    should 'create a vacation request' do
      assert_no_difference 'VacationRequest.count' do
        result = VacationRequest::Create.({
            vacation_request: {
              start_date: '30/06/2016',
              end_date: '04/07/2016'
            }
          }, employee: @employee
        )
        assert result.failure?
        assert_equal(
          {
            start_date: ['must be in 2017'],
            end_date: ['must be in 2017']
          },
          result['contract.default'].errors.messages
        )
      end

      assert_no_difference 'VacationRequest.count' do
        result = VacationRequest::Create.({
            vacation_request: {
              start_date: '30/06/2017',
              end_date: '04/06/2017'
            }
          }, employee: @employee
        )
        assert result.failure?
        assert_equal(
          {
            end_date: ['must be after start date']
          },
          result['contract.default'].errors.messages
        )
      end

      assert_no_difference 'VacationRequest.count' do
        result = VacationRequest::Create.({
            vacation_request: {
              start_date: '01/07/2017',
              end_date: '02/07/2017' # 31 workdays
            }
          }, employee: @employee
        )
        assert result.failure?
        assert_equal(
          {
            vacation_days: ['The selected period does not contain any workdays.']
          },
          result['contract.default'].errors.messages
        )
      end

      assert_no_difference 'VacationRequest.count' do
        result = VacationRequest::Create.({
            vacation_request: {
              start_date: '30/06/2017',
              end_date: '11/08/2017' # 31 workdays
            }
          }, employee: @employee
        )
        assert result.failure?
        assert_equal(
          {
            vacation_days: ['Too few vacation days left.']
          },
          result['contract.default'].errors.messages
        )
      end

      # 22 workdays
      create_vacation_request(employee: @employee, start_date: '03/04/2017', end_date: '05/05/2017')
      assert_no_difference 'VacationRequest.count' do
        result = VacationRequest::Create.({
            vacation_request: {
              # 10 workdays
              start_date: '08/05/2017',
              end_date: '19/05/2017'
            }
          }, employee: @employee
        )
        assert result.failure?
        assert_equal(
          {
            vacation_days: ['Too few vacation days left.'] # 22 pending days + 10 days for new request
          },
          result['contract.default'].errors.messages
        )
      end

      create_vacation_request(employee: @employee, start_date: '29/06/2017', end_date: '30/06/2017')
      assert_no_difference 'VacationRequest.count' do
        result = VacationRequest::Create.({
            vacation_request: {
              start_date: '30/06/2017',
              end_date: '04/07/2017'
            }
          }, employee: @employee
        )
        assert result.failure?
        assert_equal(
          {
            start_date: ['overlaps with an other vacation request']
          },
          result['contract.default'].errors.messages
        )
      end

      supervisor1 = create_supervisor
      supervisor2 = create_supervisor
      # does not get notification about his own request
      supervisor3 = create_supervisor(name: 'Garfield')

      assert_email_sent(count: 2) do
        assert_difference 'VacationRequest.count' do
          result = VacationRequest::Create.({
              vacation_request: {
                start_date: '01/07/2017',
                end_date: '04/07/2017'
              }
            }, employee: supervisor3
          )
          assert result.success?, result['contract.default'].errors.messages
        end
      end

      request = VacationRequest.last
      assert_equal 'pending', request.state
      assert_equal '01/07/2017', request.start_date.strftime('%d/%m/%Y')
      assert_equal '04/07/2017', request.end_date.strftime('%d/%m/%Y')
      assert_equal 2, request.vacation_days
      assert_equal 4, request.total_days
      assert_equal supervisor3, request.employee

      mails = ActionMailer::Base.deliveries.last(2)
      assert_equal [supervisor1, supervisor2].map(&:email).sort, mails.map(&:to).flatten.sort

      mail = mails.first
      assert_equal ['system@vacation-planner.com'], mail.from
      assert_equal 'New vacation request from Garfield', mail.subject
      assert_match %r|Garfield submitted a new vacation request.|, mail.body.to_s
      assert_match %r|Start Date: Sat, 01/07/2017|, mail.body.to_s
      assert_match %r|End Date: Tue, 04/07/2017|, mail.body.to_s
      assert_match %r|/manage_vacation_requests|, mail.body.to_s
    end

    should 'consider saarland holidays' do
      result = VacationRequest::Create.({
          vacation_request: {
            start_date: '14/06/2017',
            end_date: '16/06/2017',
          }
        }, employee: @employee
      )
      assert result.success?, result['contract.default'].errors.messages

      request = VacationRequest.last
      assert_equal 2, request.vacation_days # 15.06.2017 Corpus Christi holiday :)
      assert_equal 3, request.total_days

      result = VacationRequest::Create.({
          vacation_request: {
            start_date: '21/11/2017',
            end_date: '23/11/2017',
          }
        }, employee: @employee
      )
      assert result.success?, result['contract.default'].errors.messages

      request = VacationRequest.last
      assert_equal 3, request.vacation_days # 22.11.2017 no Buß- und Bettag in Saarland :(
      assert_equal 3, request.total_days
    end

    should 'destroy vacation requests' do
      request = create_vacation_request(employee: @employee)

      assert_no_difference 'VacationRequest.count' do
        result = VacationRequest::Destroy.({ id: request.to_param }, employee: create_employee)
        assert result.failure?
        assert_equal :access_denied, result['employee.error']
      end

      assert_difference 'VacationRequest.count', -1 do
        result = VacationRequest::Destroy.({ id: request.to_param }, employee: @employee)
        assert result.success?
      end
    end
  end

  context 'as supervisor' do
    setup do
      @supervisor = create_supervisor(name: 'Super wise')
    end

    should 'manage vacation requests' do
      request = create_vacation_request(
        employee: @employee,
        start_date: '05/07/2017',
        end_date: '06/07/2017',
      )

      assert_email_sent do
        assert_difference '@employee.reload.taken_vacation_days', 2 do
          result = VacationRequest::Manage.(
            { id: request.to_param, manage_action: 'accepted' },
            employee: @supervisor
          )
          assert result.success?, result['contract.default'].errors.messages
        end
      end
      assert_equal 'accepted', request.reload.state

      mail = ActionMailer::Base.deliveries.last
      assert_equal [@employee.email], mail.to
      assert_equal ['system@vacation-planner.com'], mail.from

      assert_equal 'Your vacation request has been accepted.', mail.subject
      assert_match %r|Super wise accepted your vacation request.|, mail.body.to_s
      assert_match %r|Start Date: Wed, 05/07/2017|, mail.body.to_s
      assert_match %r|End Date: Thu, 06/07/2017|, mail.body.to_s
      assert_match %r|Click here to see your vacation requests:|, mail.body.to_s
      assert_match %r|/vacation_requests|, mail.body.to_s

      request = create_vacation_request(
        employee: @employee,
        start_date: '07/07/2017',
        end_date: '10/07/2017',
      )

      assert_email_sent do
        assert_no_difference '@employee.reload.taken_vacation_days' do
          result = VacationRequest::Manage.(
            { id: request.to_param, manage_action: 'declined' },
            employee: @supervisor
          )
          assert result.success?, result['contract.default'].errors.messages
        end
      end
      assert_equal 'declined', request.reload.state

      mail = ActionMailer::Base.deliveries.last
      assert_equal [@employee.email], mail.to
      assert_equal ['system@vacation-planner.com'], mail.from

      assert_equal 'Your vacation request has been declined.', mail.subject
      assert_match %r|Super wise declined your vacation request.|, mail.body.to_s
      assert_match %r|Start Date: Fri, 07/07/2017|, mail.body.to_s
      assert_match %r|End Date: Mon, 10/07/2017|, mail.body.to_s
      assert_match %r|Click here to see your vacation requests:|, mail.body.to_s
      assert_match %r|/vacation_requests|, mail.body.to_s
    end
  end

end
