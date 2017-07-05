class VacationRequestMailer < ApplicationMailer

  def new_request_message(vacation_request, supervisor)
    @request = vacation_request
    @employee = @request.employee
    mail to: supervisor.email,
      subject: t('vacation_request.mailer.new.subject', name: @employee.name)
  end

  def request_managed_message(vacation_request, supervisor)
    @request = vacation_request
    @supervisor = supervisor
    mail to: @request.employee.email,
      subject: t('vacation_request.mailer.managed.subject', action: @request.state)
  end

end
