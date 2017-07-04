require 'test_helper'
require 'concepts/vacation_request/test_helper'

class VacationRequestWorkflowTest < ActionDispatch::IntegrationTest

  include VacationRequestTestHelper

  context 'as employee' do
    setup do
      @employee = create_employee
      sign_in @employee
    end

    should 'be able to create a vacation request' do
      assert has_content? 'My vacation requests'
      assert has_content? 'No vacation requests found.'
      click_on 'New vacation request'
      assert has_content? 'New vacation request'

      fill_in 'Start date', with: Date.tomorrow.strftime('%d/%m/%Y')
      fill_in 'End date', with: 1.year.from_now.strftime('%d/%m/%Y')

      assert_no_difference 'VacationRequest.count' do
        click_on 'Create'
      end

      assert has_content? 'Too few vacation days left.'

      fill_in 'Start date', with: Date.new(2017, 7, 4).strftime('%d/%m/%Y')
      fill_in 'End date', with: Date.new(2017, 7, 10).strftime('%d/%m/%Y')

      assert_difference 'VacationRequest.count' do
        click_on 'Create'
      end

      assert has_content? 'Vacation request successfully created.'
      assert has_content? 'My vacation requests'
      assert_equal 'Tue, 04/07/2017', find(:xpath, '//tbody/tr[1]/td[2]').text
      assert_equal 'Mon, 10/07/2017', find(:xpath, '//tbody/tr[1]/td[3]').text
      assert_equal '5.0', find(:xpath, '//tbody/tr[1]/td[4]').text
      assert_equal '7.0', find(:xpath, '//tbody/tr[1]/td[5]').text
      assert_equal 'pending', find(:xpath, '//tbody/tr[1]/td[6]').text

      click_on 'New vacation request'
      assert has_content? 'New vacation request'
      fill_in 'Start date', with: Date.new(2017, 7, 8).strftime('%d/%m/%Y')
      fill_in 'End date', with: Date.new(2017, 7, 9).strftime('%d/%m/%Y')

      assert_no_difference 'VacationRequest.count' do
        click_on 'Create'
      end

      assert has_content? 'The selected period does not contain any workdays.'
      assert has_content? 'overlaps with an other vacation request'
    end

    should 'delete vacation request' do
      create_vacation_request(employee: @employee)
      visit '/vacation_requests'
      assert has_content? 'pending'

      assert_difference 'VacationRequest.count', -1 do
        click_on 'Delete'
        assert has_content? 'Vacation request successfully deleted.'
      end
    end
  end

  context 'as supervisor' do
    setup do
      @supervisor = create_supervisor
      sign_in @supervisor
    end

    should 'manage vacation requests' do
      click_on 'Manage vacation requests'
      assert has_content? 'No vacation requests found.'

      employee = create_employee(name: 'Hase Fuchs')
      create_vacation_request(employee: employee)

      click_on 'Manage vacation requests'
      assert has_content? 'Hase Fuchs'
      assert has_content? 'pending'
      assert_difference 'employee.reload.taken_vacation_days', 2 do
        click_on 'Accept'
      end
      assert has_content? 'The vacation request has been accepted.'
      assert_equal 'accepted', find(:xpath, '//tbody/tr[1]/td[7]').text

      create_vacation_request(
        employee: employee,
        start_date: '01/01/2017',
        end_date: '01/02/2017'
      )

      click_on 'Manage vacation requests'
      assert has_content? 'pending'

      assert_no_difference 'employee.reload.taken_vacation_days' do
        find(:xpath, '//tbody/tr[2]').click_on 'Decline'
      end
      assert has_content? 'The vacation request has been declined.'
      assert_equal 'declined', find(:xpath, '//tbody/tr[2]/td[7]').text
    end

    should 'have sortable vacation requests' do
      create_vacation_request(
        employee: @supervisor,
        start_date: '01/01/2017',
        end_date: '01/02/2017'
      )
      create_vacation_request(
        employee: @supervisor,
        start_date: '02/02/2017',
        end_date: '05/02/2017'
      )

      click_on 'Manage vacation requests'
      assert has_content? 'Status'
      assert has_content? '05/02/2017'

      click_on 'Start Date'
      assert_equal 'Sun, 01/01/2017', find(:xpath, '//tbody/tr[1]/td[2]').text
      assert_equal 'Thu, 02/02/2017', find(:xpath, '//tbody/tr[2]/td[2]').text

      click_on 'Start Date'
      sleep 0.3
      assert has_content? 'Start Date' # find doesn't wait
      assert_equal 'Thu, 02/02/2017', find(:xpath, '//tbody/tr[1]/td[2]').text
      assert_equal 'Sun, 01/01/2017', find(:xpath, '//tbody/tr[2]/td[2]').text

      click_on 'End Date'
      sleep 0.3
      assert_equal 'Sun, 01/01/2017', find(:xpath, '//tbody/tr[1]/td[2]').text
      assert_equal 'Thu, 02/02/2017', find(:xpath, '//tbody/tr[2]/td[2]').text

      click_on 'End Date'
      sleep 0.3
      assert_equal 'Thu, 02/02/2017', find(:xpath, '//tbody/tr[1]/td[2]').text
      assert_equal 'Sun, 01/01/2017', find(:xpath, '//tbody/tr[2]/td[2]').text
    end
  end

end
