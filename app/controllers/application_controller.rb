class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  before_action :authenticate_employee!
  layout 'application'

  private

  def authorize_supervisor
    redirect_to root_path unless current_employee.supervisor?
  end

end
