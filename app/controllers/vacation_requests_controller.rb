class VacationRequestsController < ApplicationController

  before_action :authorize_supervisor, only: %i(manage update)

  def index
    @requests = VacationRequest::Twin.from_collection(
      current_employee.vacation_requests.order_by(params))
  end

  def new
    run VacationRequest::Create::Present
  end

  def create
    result = run VacationRequest::Create do |result|
      redirect_to vacation_requests_path, VacationRequest::Create::Flash.(result)
      return
    end
    message = VacationRequest::Create::Flash.(result)
    flash.now[message.first] = message.last if message.present?
    render 'new'
  end

  def destroy
    result = run VacationRequest::Destroy
    redirect_to vacation_requests_path, VacationRequest::Destroy::Flash.(result)
  end

  def manage
    @requests = VacationRequest::Twin.from_collection(
      VacationRequest.includes(:employee).order_by(params)
    )
  end

  def update
    result = run VacationRequest::Manage
    redirect_to manage_vacation_requests_path, VacationRequest::Manage::Flash.(result)
  end

  private

  def _run_options(_)
    { employee: current_employee }
  end

end
