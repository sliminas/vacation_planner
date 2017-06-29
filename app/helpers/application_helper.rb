module ApplicationHelper

  def flash_message
    out = ''.html_safe
    flash.each do |name, msg|
      clazz = {
        notice: :success,
        alert: :warning,
        error: :danger,
        info: :info
      }[name&.to_sym]
      out << content_tag(:div, msg, class: "alert alert-#{clazz}")
    end
    out
  end

  def navigation_entries
    entries = []
    if current_employee
      entries << [t('vacation_request.model_name', count: 2), vacation_requests_path]
      entries << [t('employee.model_name', count: 2), employees_path] if supervisor?
      entries << [t('misc.sign_out'), destroy_employee_session_path, { method: :delete }]
      entries << [t('misc.signed_in_employee', name: current_employee.name)]
    else
    end
    entries
  end

  def navigation_links(entries: navigation_entries)
    nav = ''.html_safe
    entries.each do |text, path, **options|
      nav <<
        if path
          link_to(text, path, options.merge(class: 'nav-item nav-link'))
        else
          content_tag :span, text, options.merge(class: 'navbar-text')
        end
    end
    nav
  end

  def supervisor?
    current_employee.supervisor?
  end


end
