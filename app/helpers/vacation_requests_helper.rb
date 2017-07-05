module VacationRequestsHelper

  def manage?
    action_name == 'manage'
  end

  def input_type(property)
    case property
    when :email
      :email_field
    when :vacation_days
      :number_field
    else
      :text_field
    end
  end
end
