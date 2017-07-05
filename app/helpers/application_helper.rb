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
      entries << [t('nav.vacation_requests'), vacation_requests_path]
      if supervisor?
        entries << [t('nav.manage_vacation_requests'), manage_vacation_requests_path]
        entries << [t('employee.model_name', count: 2), employees_path]
      end
      entries << [t('misc.sign_out'), destroy_employee_session_path, { method: :delete }]
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

  def sort_dir(property)
    currently_sorted = property.to_s == params[:sort]
    (params[:sort_dir] == 'asc' && currently_sorted) ? :desc : :asc
  end

  def sort_link(property, path, i18n_scope: 'vacation_request.table.th', **options)
    link_to t("#{i18n_scope}.#{property}"),
      send(path.to_sym, sort: property, sort_dir: sort_dir(property)),
      class: options[:class]
  end

  def sort_button(property, path, i18n_scope: 'vacation_request.table.th')
    sort_link(property, path, i18n_scope: i18n_scope, class: sort_button_class(property))
  end

  def sort_button_class(property)
    clazz = 'btn btn-secondary btn-sm'
    if params[:sort] == property.to_s
      clazz += ' active'
      clazz += ' desc' if params[:sort_dir] == 'desc'
    end
    clazz
  end

end
