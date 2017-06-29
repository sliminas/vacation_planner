class EmployeesController < ApplicationController

  before_action :authorize_supervisor

  def index
    @employees = Employee.all
  end

  def new
    run Employee::Create::Present
  end

  private

  def authorize_supervisor
    redirect_to root_path unless current_employee.supervisor?
  end

end
