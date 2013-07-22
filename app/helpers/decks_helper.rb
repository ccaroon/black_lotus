module DecksHelper

  def color_to_badge(color)
    badge = case color
    when :red
      'badge-important'
    when :green
      'badge-success'
    when :blue
      'badge-info'
    when :black
      'badge-inverse'
    when :white
      'badge-warning'
    else
      ''
    end

    return(badge)
  end

  def deck_error?(attr)
    display_error_if_error @deck, attr
  end
  
end
