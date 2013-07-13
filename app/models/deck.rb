class Deck < ActiveRecord::Base
  
  ##############################################################################
  attr_accessible :name, :format

  validates_presence_of :name, :format

  has_many :card_in_deck, :order => 'main_copies asc'
  has_many :cards,        :through => :card_in_deck, :order => 'name'
  ##############################################################################
  def main_count
    count = 0
    card_in_deck.each do |a|
      count += a.main_copies
    end

    return (count);
  end
  ##############################################################################
  def side_count
    count = 0
    card_in_deck.each do |a|
      count += a.side_copies
    end
  
    return (count);
  end
  ##############################################################################
  def add_card(card, options = {:main_copies => 1, :side_copies => 0})
    card_in_deck = CardInDeck.new(
      :deck => self,
      :card => card,
      :main_copies => options[:main_copies],
      :side_copies => options[:side_copies]
    )

    card_in_deck.save!
  end
  ##############################################################################
  def remove_card(card)

    # ideally this should work, but isn't
    # self.cards.destroy(card)
    # or this
    # self.card_in_deck.destroy(card)

    index = self.card_in_deck.find_index do |cid|
      cid.card.id == card.id
    end

    card_in_deck = self.card_in_deck[index]
    raise "Failed to destroy #{card_in_deck.inspect}" unless card_in_deck.destroy
  end
end
