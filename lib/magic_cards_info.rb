# encoding: utf-8
require 'csv'
require 'httparty'
require 'nokogiri'

class MagicCardsInfo
  include HTTParty
  base_uri "http://magiccards.info"

  INDEX = {
    number:    0,
    name:      1,
    type_line: 2,
    mana_cost: 3,
    rarity:    4,
    artist:    5,
    edition:   6    
  }

  ##############################################################################
  def self.info(key,card,edition = nil)
    raise "Unknown key [#{key}]" unless INDEX.key?(key.to_sym)

    edition = card.latest_edition if edition.nil?

    card_data = find_data_for(card,edition)
    key_index = INDEX[key.to_sym]

    return (card_data[key_index])
  end
  ##############################################################################
  def self.download_image(card, edition = nil)
    card.gen_image_name
    img_url = image_url(card, edition)

    r = self.get(img_url)
    raise "#{img_url} -- #{r.message}" unless r.code == 200

    File.open( "#{Rails.public_path}/card_images/#{card.image_name}", "wb") do |img|
      img << r.body
    end
  end
  ##############################################################################
  def self.fetch_info(card)

    info = {}

    # Type & Subtype: "Creature — Human Wizard 2/2"
    type_line = self.info(:type_line, card)
    (type, sub_type) =  type_line.split(/\xE2\x80\x94/, 2)
    type.strip!
    type.sub!(/\s+[0-9*]+\/[0-9*]+$/,'') #strip off power/toughness
    info[:main_type] = type
    
    sub_type ||= ''
    sub_type.strip!
    sub_type.sub!(/\s+[0-9*]+\/[0-9*]+$/,'') #strip off power/toughness
    info[:sub_type] = sub_type

    info[:mana_cost] = self.info(:mana_cost, card)
    info[:rarity]    = self.info(:rarity, card)
    info[:text_box]  = self.fetch_text_box(card) 

    return info
  end
  ##############################################################################
  private
  ##############################################################################
  def self.image_url(card, edition = nil)
    edition = card.latest_edition if edition.nil?
    ed_code = edition.online_code
    card_num = self.info(:number, card, edition)

    url = "/scans/en/#{ed_code}/#{card_num}.jpg"

    return(url)
  end
  ##############################################################################
  def self.fetch_card_list(edition)
    code = edition.online_code
    url = "/#{code}/en.html"

    r = self.get(url)
    raise "#{url} -- #{r.message}" unless r.code == 200

    doc = Nokogiri::HTML(r.body)

    list = []
    doc.xpath('/html/body/table[3]/tr').each do |row|
      next unless row['class'] =~ /^(even|odd)$/
      card = []
      row.xpath('td').each do |td|
        card << td.content
      end
      list << card
    end

    CSV.open("#{Rails.root}/tmp/card_list_#{code}.csv", "wb") do |csv|
      list.each do |card|
        csv << card
      end
    end
  end
  ##############################################################################
  def self.find_data_for(card, edition)
    ed_code = edition.online_code
    card_list_file = "#{Rails.root}/tmp/card_list_#{ed_code}.csv"
    unless (File.exists?(card_list_file))
      fetch_card_list(edition)
    end

    card_row = []
    CSV.foreach(card_list_file) do |row|
      # Case insensitive compare
      if (row[INDEX[:name]].casecmp(card.name) == 0)
        card_row = row
        break
      end
    end

    return (card_row)
  end
  ##############################################################################
  def self.fetch_text_box(card)

    card_num = self.info(:number, card)
    ed_code = card.latest_edition.online_code
    raise "Edition code not set for '#{card.latest_edition.name}'" if ed_code.nil?

    url = "/#{ed_code}/en/#{card_num}.html"
    r = self.get(url)
    raise "#{url} -- #{r.message}" unless r.code == 200

    html = r.body

    raise "MagicCardsInfo Error: Card named '#{card.name}' not found." if
      html =~ /Your query did not match any cards/

    doc = Nokogiri::HTML(html)

    ctext = doc.at_xpath('/html/body/table[3]/tr/td[2]/p[2]/b').inner_html
    text_box = ''
    if (!ctext.empty?)
      text_box = ctext
      text_box.gsub!(/<br>/, "\n")
    end

    return (text_box)
  end

end
