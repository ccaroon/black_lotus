module DecksHelper

  def deck_error?(attr)
    display_error_if_error @deck, attr
  end
  
end
