require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

ENV['BACKTRACE'] = 'blegga'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'capybara-screenshot/minitest'

require 'concepts/employee/test_helper'

# delete previous stored files ...
FileUtils.rm_rf Dir.glob(Rails.root.join('tmp', 'capybara', '*'))

class ActiveSupport::TestCase

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

  include EmployeeTestHelper

  def assert_email_sent(count: 1)
    assert_difference 'ActionMailer::Base.deliveries.size', count do
      perform_enqueued_jobs do
        yield
      end
    end
  end

end

class ActionDispatch::IntegrationTest

  include Capybara::DSL
  include Capybara::Screenshot::MiniTestPlugin

  Capybara.default_max_wait_time = 5
  Capybara.default_driver = :poltergeist

  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, phantomjs: Phantomjs.path)
  end

  def sign_in(employee, password: '#password123')
    visit '/'
    assert has_content? 'VacationPlanner'
    assert has_content? 'Email'

    fill_in 'Email', with: employee.email
    fill_in 'Password', with: password

    click_on 'Sign in'
    assert has_content? 'Signed in successfully.'
  end

end
