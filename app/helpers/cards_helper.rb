module CardsHelper
  def rarity_to_html
    css_class = ''
    
    case @card.rarity
    when 'Common'      then css_class = ''
    when 'Uncommon'    then css_class = 'badge'
    when 'Rare'        then css_class = 'badge badge-warning'
    when 'Mythic Rare' then css_class = 'badge badge-important'
    end
    
    return css_class;
  end
  
  def mana_cost_to_html
  end
  
end
