require 'utility'
require 'magic_cards_info'

start_name = ARGV.shift

do_fetch = false
total = Card.count
index = 0
Card.order('name').all.each do |card|
  index+=1
  next if card.main_type == 'Scheme'

  if (card.name == start_name)
    do_fetch = true
  end
  next unless do_fetch

  puts "#{card.name} -- #{index}/#{total}"
  Utility.fetch_card_info(card)

end
