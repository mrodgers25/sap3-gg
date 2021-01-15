module SidebarHelper

  def disabled_class(current_user)
    return if current_user

    'disabled side-nav-disabled '
  end

end
