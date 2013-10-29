require 'csv'

class Utility
  ##############################################################################
  def self.export_cards(format = :handbase)
    case format
    when :handbase
      self.export_for_handbase()
    when :mtgprice
      self.export_for_mtgprice()
    end
  end
  ##############################################################################
  def self.export_for_handbase
    file_name = "#{Rails.root}/tmp/cards-handbase-#{Time.now.to_s.gsub(/[^0-9]/, '')}.csv"
    CSV.open(file_name, "wb") do |csv|
      Card.all.each do |card|
        edition_str = card.editions.map {|e| e.name}.join('|')
        # Order needs to match order of HanDbase cols
        csv << [card.name, card.main_type, card.sub_type, edition_str, 
                card.mana_cost, 0, (card.foil ? 1 : 0), card.rarity,
                card.count, nil, card.image_name]
      end
    end

    return (file_name)
  end
  ##############################################################################
  def self.export_for_mtgprice_by_100
    count = Card.count
    num_files = count / 100
    num_files += 1 if count % 100 != 0

    1.upto(num_files) do |i|
      file_name = "#{Rails.root}/tmp/cards-mtgprice-#{i}.csv"
      File.open(file_name, "wb") do |file|
        Card.page(i).per(100).each do |card|
          edition = card.editions.pop
          edition_str = edition.name =~ /^Magic 20/ ? 
            edition.code_name                       : 
            edition.name

          file << "#{card.count}, #{card.name}, #{edition_str}\n"
        end
      end
    end
  end  
  ##############################################################################
  def self.export_for_mtgprice
    file_name = "#{Rails.root}/tmp/cards-mtgprice-#{Time.now.to_s.gsub(/[^0-9]/, '')}.csv"
    File.open(file_name, "wb") do |file|
      Card.all.each do |card|
        edition = card.editions.pop
        edition_str = edition.name =~ /^Magic 20/ ? 
          edition.code_name                       : 
          edition.name

        file << "#{card.count}, #{card.name}, #{edition_str}\n"
      end
    end

    return (file_name)    
  end
  ##############################################################################
  def self.fetch_card_info(card)
      info = MagicCardsInfo.fetch_info(card)

      MagicCardsInfo.download_images(card)

      card.text_box = info.delete(:text_box)

      mismatches = {}
      info.each_pair do |attr, val|
        m = card.method(attr)
        mismatches[attr] = val unless m.call == val
      end

      return (mismatches)
  end
end
