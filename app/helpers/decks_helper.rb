module DecksHelper

  def color_to_label(color)
    label = case color
    when :red
      'label label-danger'
    when :green
      'label label-success'
    when :blue
      'label label-primary'
    when :black
      'label label-inverse'
    when :white
      'label label-warning'
    else
      'label label-default'
    end

    return(label)
  end

  def deck_error?(attr)
    return @deck.errors[attr].present?
  end

  def display_deck_error(attr)
    display_error_if_error @deck, attr
  end
  
end
