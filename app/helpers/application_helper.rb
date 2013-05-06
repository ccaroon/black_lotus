module ApplicationHelper

  ##############################################################################
  def menu_item_active?(name)
    active = params[:controller] == name ? 'active' : ''
    return active
  end
  ##############################################################################
  def card_image_path(card)
    image_path = File.exist?("#{Rails.public_path}/card_images/#{card.image_name}")  ?
      "/card_images/#{card.image_name}" :
      "http://placehold.it/312x445/888888/000000&text=#{card.name}"

    return image_path;
  end
  ##############################################################################
  
end