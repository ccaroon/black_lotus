module CardsHelper

  def rarity_to_css(card_or_rarity)
    css_class = ''
    
    rarity = card_or_rarity.is_a?(Card) ? card_or_rarity.rarity : card_or_rarity
    
    case rarity
    when 'Common'      then css_class = 'badge badge-inverse'
    when 'Uncommon'    then css_class = 'badge'
    when 'Rare'        then css_class = 'badge badge-warning'
    when 'Mythic Rare' then css_class = 'badge badge-important'
    end

    return css_class;
  end
  
  def mana_cost_to_html
  end
  
end
