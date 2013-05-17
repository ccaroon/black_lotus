require 'httparty'

class MagicCardsInfo
  include HTTParty
  base_uri "http://magiccards.info"
  ##############################################################################
  def self.fetch_image(card, img_url)
    card.gen_image_name

    r = self.get(img_url)
    raise r.message unless r.code == 200

    File.open( "#{Rails.public_path}/card_images/#{card.image_name}", "wb") do |img|
      img << r.body
    end
  end
  ##############################################################################
  def self.fetch_info(card)
    card_name = card.name

    url = "/query?q=!#{card_name.gsub(/\s+/, '+')}"
    r = self.get(url)
    raise r.message unless r.code == 200

    info = {}
    html = r.body

    raise "MagicCardsInfo Error: Card named '#{card.name}' not found." if
      html =~ /Your query did not match any cards/

    # Image URL
    base_img_url = "/scans"
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
      info[:main_type] = type
      
      sub_type ||= ''
      sub_type.strip!
      sub_type.sub!(/\s+[0-9*]+\/[0-9*]+$/,'') #strip off power/toughness
      info[:sub_type] = sub_type

      # Mana Cost
      mana_cost.strip!
      (cost, converted_cost) =  mana_cost.split(/\s+/, 2)

      info[:mana_cost] = cost

      # TODO: uncomment after figuring out what to do with this
      #converted_cost.gsub!(/(\(|\))/,'')
      #info[:converted_mana_cost] = converted_cost || cost

      # Card Text
      info[:text_box] = ''
      if (!ctext.empty?)
          info[:text_box] = ctext
          info[:text_box].gsub!(/<br>/, "\n")
      end

      # Flavor Text
      # TODO: uncomment after adding flavor text support
      #info[:flavor_text] = ''
      #if (!ftext.empty?)
      #    info[:flavor_text] = ftext
      #    info[:flavor_text].gsub!(/<br>/,"\n")
      #end
    end

    return info
  end
  
end
