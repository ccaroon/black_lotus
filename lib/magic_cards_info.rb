# encoding: utf-8
require 'httparty'
require 'nokogiri'

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

    html = r.body

    raise "MagicCardsInfo Error: Card named '#{card.name}' not found." if
      html =~ /Your query did not match any cards/

    info = self.parse_html(html)

    return info
  end
  ##############################################################################
  def self.parse_html(html)

    info = {}
    doc = Nokogiri::HTML(html)

    info[:image_url] = doc.at_xpath('/html/body/table[3]/tr/td/img').attr(:src)
    info[:image_url].sub!(/^http:\/\/magiccards.info/, '')

    type_str = doc.at_xpath('/html/body/table[3]/tr/td[2]/p').content
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

    ctext = doc.at_xpath('/html/body/table[3]/tr/td[2]/p[2]/b').inner_html
    info[:text_box] = ''
    if (!ctext.empty?)
      info[:text_box] = ctext
      info[:text_box].gsub!(/<br>/, "\n")
    end

    return (info)
  end

end
