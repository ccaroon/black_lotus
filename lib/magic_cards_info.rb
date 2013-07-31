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

    card_num = self.info(:number, card)
    ed_code = card.latest_edition.online_code
    raise "Edition code not set for '#{card.latest_edition.name}'" if ed_code.nil?

    url = "/#{ed_code}/en/#{card_num}.html"
    r = self.get(url)
    raise "#{url} -- #{r.message}" unless r.code == 200

    html = r.body

    raise "MagicCardsInfo Error: Card named '#{card.name}' not found." if
      html =~ /Your query did not match any cards/

    info = parse_html(html)
    info[:rarity] = self.info(:rarity, card)

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
  # TODO: change to use edition card list
  def self.parse_html(html)

    info = {}
    doc = Nokogiri::HTML(html)

    # info[:image_url] = doc.at_xpath('/html/body/table[3]/tr/td/img').attr(:src)
    # info[:image_url].sub!(/^http:\/\/magiccards.info/, '')

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
    unless (mana_cost.nil?)
      mana_cost.strip!
      (cost, converted_cost) =  mana_cost.split(/\s+/, 2)
      info[:mana_cost] = cost
    end

    ctext = doc.at_xpath('/html/body/table[3]/tr/td[2]/p[2]/b').inner_html
    info[:text_box] = ''
    if (!ctext.empty?)
      info[:text_box] = ctext
      info[:text_box].gsub!(/<br>/, "\n")
    end

    return (info)
  end

end
