module EditionsHelper

  def edition_error?(attr)
    return @edition.errors[attr].present?
  end

  def display_edition_error(attr)
    display_error_if_error @edition, attr
  end

end
