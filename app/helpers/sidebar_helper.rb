module SidebarHelper
  def disabled_class(current_user)
    return if current_user

    'disabled side-nav-disabled'
  end

  def active_item?(path)
    current_page?(path) ? 'active-item' : 'bg-white'
  end

  def nav_item_link(path, text, icon, disabled: false)
    classes_string = "list-group-item list-group-item-action #{disabled_class(current_user) if disabled}"
    classes_string += current_page?(path) ? 'active-item' : 'bg-white'

    link_to(path, { class: classes_string }) do
      content_tag(:i, "", class: "fas #{icon} mr-2") + text
    end
  end
end
