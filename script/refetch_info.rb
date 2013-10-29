require 'utility'
require 'magic_cards_info'

start_name  = ARGV.shift
images_only = ARGV.shift || false

do_fetch = start_name == 'ALL' ? true : false
total = Card.count
index = 0
Card.order('name').all.each do |card|
  index+=1
  next if card.main_type == 'Scheme'

  if (do_fetch == false && card.name == start_name)
    do_fetch = true
  end
  next unless do_fetch

  puts "#{card.name} -- #{index}/#{total}"

  if (images_only)
    MagicCardsInfo.download_images(card)
  else
    Utility.fetch_card_info(card)
  end

end
