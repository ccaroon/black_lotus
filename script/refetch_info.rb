require 'utility'
require 'magic_cards_info'

Card.all.each do |card|
  next if card.main_type == 'Scheme'
  next if card.main_type == 'Basic Land'

  puts card.name
  Utility.fetch_card_info(card)
end
