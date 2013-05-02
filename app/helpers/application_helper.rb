module ApplicationHelper
  
  def menu_item_active?(name)
    active = params[:controller] == name ? 'active' : ''
    return active;
  end
  
end
