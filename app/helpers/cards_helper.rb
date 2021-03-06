module CardsHelper

  def rarity_to_css(card_or_rarity)
    css_class = ''

    rarity = card_or_rarity.is_a?(Card) ? card_or_rarity.rarity : card_or_rarity

    case rarity
    when 'Common'      then css_class = 'label label-inverse'
    when 'Uncommon'    then css_class = 'label label-default'
    when 'Rare'        then css_class = 'label label-warning'
    when 'Mythic Rare' then css_class = 'label label-danger'
    end

    return css_class;
  end

  def mana_cost_to_html(mana_cost)
    html = mana_cost.dup
    html.gsub!(/(X|-|\d+)/, '<span class="badge mana">\1</span>')
    html.gsub!(/R/, '<span class="badge badge-danger mana">R</span>')
    html.gsub!(/G/, '<span class="badge badge-success mana">G</span>')
    html.gsub!(/U/, '<span class="badge badge-primary mana">U</span>')
    html.gsub!(/B/, '<span class="badge badge-inverse">B</span>')
    html.gsub!(/W/, '<span class="badge badge-white mana">W</span>')
    html.gsub!(/C/, '<span class="badge mana">♢</span>')

    return html.html_safe
  end

  def card_error?(attr)
    display_error_if_error @card, attr
  end

  def card_data_mismatch?(attr)
    html = '';
    if @card_data_mismatches.present? and @card_data_mismatches.key?(attr.to_sym)
      html = "<span class='label label-info'>...#{attr.to_s.titlecase} mis-match: '#{@card_data_mismatches[attr.to_sym]}'</span>"
    end

    return html.html_safe
  end

end
