module ApplicationHelper

  ##############################################################################
  def menu_item_active?(name)
    active = params[:controller] == name ? 'active' : ''
    return active
  end
  ##############################################################################
  def card_image_path(card, edition = card.latest_edition)
    image_path = card.image_path(edition)
    unless (File.exist?("#{Rails.public_path}/#{image_path}"))
      image_path = "http://placehold.it/312x445/888888/000000&text=#{card.name}+(#{edition.code_name})"
    end

    return image_path
  end
  ##############################################################################
  def display_error_if_error(model, attr)
    html = '';
    if model.errors[attr.to_sym].present?
      model.errors[attr.to_sym].each do |msg|
        html += "<span class='label label-danger'>...#{msg.titlecase}</span>"
      end
    end

    return html.html_safe
  end
  ##############################################################################
  def flash_class(level)
      case level
          when :notice then "alert-info"
          when :success then "alert-success"
          when :error then "alert-danger"
          when :alert then "alert-warning"
      end
  end  
end
