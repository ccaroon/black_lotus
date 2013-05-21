module ApplicationHelper

  ##############################################################################
  def menu_item_active?(name)
    active = params[:controller] == name ? 'active' : ''
    return active
  end
  ##############################################################################
  def card_image_exists?(card)
    File.exist?("#{Rails.public_path}/card_images/#{card.image_name}")
  end
  ##############################################################################
  def card_image_path(card)
    image_path = card_image_exists?(card)  ?
      "/card_images/#{card.image_name}" :
      "http://placehold.it/312x445/888888/000000&text=#{card.name}"

    return image_path;
  end
  ##############################################################################
  def display_error_if_error(model, attr)
    html = '';
    if model.errors[attr.to_sym].present?
      model.errors[attr.to_sym].each do |msg|
        html += "<span class='label label-important'>...#{msg.titlecase}</span>"
      end
    end

    return html.html_safe
  end
  
end
