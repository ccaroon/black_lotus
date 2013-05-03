require 'httparty'

class MagicCardsInfo
  include HTTParty
  base_uri "http://magiccards.info"
  
  def self.fetch(card_name)
    r = self.get("/query?q=!#{card_name.sub(/\s+/, '+')}")
    raise r.message unless r.code == 200
    
    info = {}
    html = r.body

    # Image URL
    base_img_url = "http://magiccards.info/scans"
    while(html.sub!(/<img src="http:\/\/magiccards.info\/scans\/(.*)\.jpg"\s+alt="([^"]+)"/,''))
      img_name = $1
      alt_txt  = $2

      if (alt_txt.downcase == card_name.downcase)
          info[:image_url] = "#{base_img_url}/#{img_name}.jpg"
          break
      end
    end

    # Type, Subtype, Mana Cost, Card Text & Flavor Text
    if (html.match(/<p>(.*)<\/p>\s*<p class="ctext"><b>(.*?)<\/b><\/p>\s+<p><i>(.*?)<\/i><\/p>/m))
      type_str = $1
      ctext    = $2
      ftext    = $3

      type_str.gsub!(/\n/,'')
      (type_info, mana_cost) =  type_str.split(/,/, 2)

      # Type & Subtype
      (type, sub_type) =  type_info.split(/\xE2\x80\x94/, 2)
      type.strip!
      type.sub!(/\s+[0-9*]+\/[0-9*]+$/,'') #strip off power/toughness
      info[:type] = type
      
      sub_type ||= ''
      sub_type.strip!
      sub_type.sub!(/\s+[0-9*]+\/[0-9*]+$/,'') #strip off power/toughness
      info[:sub_type] = sub_type

      # Mana Cost
      mana_cost.strip!
      (cost, converted_cost) =  mana_cost.split(/\s+/, 2)

      info[:mana_cost] = cost

      converted_cost.gsub!(/(\(|\))/,'')
      info[:converted_mana_cost] = converted_cost || cost

      # Card Text
      info[:card_text] = ''
      if (!ctext.empty?)
          info[:card_text] = ctext
          info[:card_text].gsub!(/<br>/, "\n")
      end

      # Flavor Text
      info[:flavor_text] = ''
      if (!ftext.empty?)
          info[:flavor_text] = ftext
          info[:flavor_text].gsub!(/<br>/,"\n")
      end
    else
      info[:card_text] = nil
    end

    return info
  end
  
end
