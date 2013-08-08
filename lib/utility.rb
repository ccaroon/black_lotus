require 'csv'

class Utility
  ##############################################################################
  def self.export_cards
    file_name = "#{Rails.root}/tmp/cards-#{Time.now.to_s.gsub(/[^0-9]/, '')}.csv"
    CSV.open(file_name, "wb") do |csv|
      Card.all.each do |card|
        edition_str = card.editions.map {|e| e.name}.join('|')
        # Order needs to match order of HanDbase cols
        csv << [card.name, card.main_type, card.sub_type, edition_str, 
                card.mana_cost, 0, card.foil, card.rarity,
                card.count, nil, card.image_name]
      end
    end

    return (file_name)
  end
  ##############################################################################
  def self.fetch_card_info(card)
      info = MagicCardsInfo.fetch_info(card)

      MagicCardsInfo.download_image(card)

      card.text_box = info.delete(:text_box)

      mismatches = {}
      info.each_pair do |attr, val|
        m = card.method(attr)
        mismatches[attr] = val unless m.call == val
      end

      return (mismatches)
  end
end
