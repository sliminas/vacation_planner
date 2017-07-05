require 'test_helper'

class EmployeeWorkflowTest < ActionDispatch::IntegrationTest

  context 'as employee' do
    setup do
      @employee = create_employee
    end

    should 'be able to sign in and out' do
      sign_in @employee

      assert has_content? 'My vacation requests'
      assert has_content? 'No vacation requests found.'
      assert has_content? "Signed in as #{@employee.name}"

      assert has_content? 'Vacation Days: 30.0'
      assert has_content? 'Taken: 0.0'
      assert has_content? 'Unaccepted: 0.0'
      assert has_content? 'Remaining: 30.0'

      assert has_no_link? 'Employees'
      click_on 'Sign out'
      assert has_content? 'Signed out successfully.'
    end
  end

  context 'as supervisor' do
    setup do
      @supervisor = create_supervisor(name: 'Zupervisor')
      sign_in @supervisor
    end

    should 'create employee' do
      click_on 'Employees'
      assert has_content? 'Employees'
      assert has_content? @supervisor.email
      assert has_content? 'Email'
      assert has_content? 'Supervisor'

      click_on 'New employee'
      assert has_content? 'New employee'
      assert has_field? 'Supervisor'
      assert has_no_checked_field? 'Supervisor'

      fill_in 'Name', with: 'Employee of the year'
      fill_in 'Email', with: 'email@oftheyear.de'
      fill_in 'Password', with: 'new_sEcretPa$$W0rd'
      fill_in 'Vacation days', with: 'skaldjf'

      assert_no_difference 'Employee.count' do
        click_on 'Create'
      end

      assert has_content? 'is not a number'
      fill_in 'Vacation days', with: 12.5

      assert_difference 'Employee.count' do
        click_on 'Create'
        assert has_content? 'Employee successfully created.'
      end

      assert has_content? 'email@oftheyear.de'
      assert has_content? 'Employee of the year'
    end

    context 'with existing employees' do
      setup do
        @employee = create_employee(name: 'Example employee')
        visit '/employees'
      end

      should 'update employee' do
        assert has_content? 'Employees'
        assert has_content? 'Example employee'
        find(:xpath, '//tbody/tr[2]').click_on 'Edit'

        assert has_content? 'Edit employee'
        assert_equal 'Example employee', find_field('employee_name').value
        check 'Supervisor'
        fill_in 'Name', with: 'Other employee'
        click_on 'Save'

        assert has_content? 'Employee successfully updated.'
        assert has_content? 'Other employee'
        assert has_no_content? 'Example employee'
      end

      should 'delete employee' do
        assert_difference 'Employee.count', -1 do
          find(:xpath, '//tbody/tr[2]').click_on 'Delete'
          assert has_content? 'Employee successfully deleted.'
        end
        assert has_no_content? 'Example employee'
        assert has_content? @supervisor.email
      end
    end
  end

end
