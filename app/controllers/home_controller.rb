class HomeController < ApplicationController

  skip_before_action :authenticate_employee!

  def index
    redirect_to(employee_signed_in? ? vacation_requests_path : new_employee_session_path)
  end

end
