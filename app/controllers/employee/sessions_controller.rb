class Employee::SessionsController < Devise::SessionsController

  prepend_before_action :require_no_authentication, only: %i(new create)

  layout 'application'

  private

  def after_sign_out_path_for(resource)
    root_path
  end

end
