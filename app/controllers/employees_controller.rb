class EmployeesController < ApplicationController

  before_action :authorize_supervisor

  def index
    @employees = Employee::Twin.from_collection(
      Employee.order_by(params).eager_count(:vacation_requests)
    )
  end

  def new
    run Employee::Create::Present
  end

  def create
    run Employee::Create do
      redirect_to employees_path, notice: t('employee.create.success')
      return
    end
    render 'new'
  end

  def edit
    run Employee::Present
  end

  def update
    run Employee::Update do
      redirect_to employees_path, notice: t('employee.update.success')
      return
    end
    render 'new'
  end

  def destroy
    result = run Employee::Destroy
    redirect_to employees_path, Employee::Destroy::Flash.(result)
  end

end
