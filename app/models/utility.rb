require 'csv'

class Utility
  ##############################################################################
  def self.export_cards
    file = "#{Rails.root}/tmp/cards-#{Time.now.to_s.gsub(/[^0-9]/, '')}.csv"
    CSV.open(file, "wb") do |csv|
      Card.all.each do |card|
        edition_str = card.editions.map {|e| e.name}.join('|')
        # Order needs to match order of HanDbase cols
        csv << [card.name, card.main_type, card.sub_type, edition_str, 
                card.mana_cost, card.legal?, card.foil, card.rarity,
                card.count, nil, card.image_name]
      end
    end
  end
  ##############################################################################
  def self.fetch_card_info(card)
      info = MagicCardsInfo.fetch_info(card)

      img_url = info.delete(:image_url)
      MagicCardsInfo.fetch_image(card, img_url) unless img_url.nil?

      card.text_box = info.delete(:text_box)

      mismatches = {}
      info.each_pair do |attr, val|
        m = card.method(attr)
        mismatches[attr] = val unless m.call == val
      end

      return (mismatches)
  end
end
