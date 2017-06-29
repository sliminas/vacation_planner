require 'test_helper'

class EmployeeWorkflowTest < ActionDispatch::IntegrationTest

  context 'as employee' do
    setup do
      @employee = create_employee
    end

    should 'be able to login' do
      sign_in @employee

      assert has_content? 'Vacation requests'
      assert has_content? 'No vacation requests found.'
      assert has_content? 'Signed in as Max Muster'
      assert has_no_link? 'Employees'
    end
  end

  context 'as supervisor' do
    setup do
      @supervisor = create_supervisor
      sign_in @supervisor
    end

    should 'create new employee' do
      click_on 'Employees'
      assert has_content? 'Employees'
      assert has_content? @supervisor.email
      assert has_content? 'Email'
      assert has_content? 'Supervisor'

      click_on 'New employee'
      assert has_content? 'New employee'
      fill_in 'Name', with: 'Employee of the year'
      fill_in 'Email', with: 'email@oftheyear.de'
      fill_in 'Password', with: 'new_sEcretPa$$W0rd'
      fill_in 'Vacation days', with: 'skaldjf'
      # TODO assert find unchecked supervisor checkbox

      click_on 'Create emloyee'

      assert has_content? 'Vacation days must be a number'
      fill_in 'Vacation days', with: 12.5

      assert_difference 'Employee.count' do
        # assert_email_sent do
          click_on 'Create emloyee'
        # end
      end

      assert has_content? 'Employee successfully created.'

      mail = ActionMailer::Base.deliveries.last
      assert_equal 'email@oftheyear.de', mail.to
    end
  end

end
