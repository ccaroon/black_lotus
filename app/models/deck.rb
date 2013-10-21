class Deck < ActiveRecord::Base
  
  ##############################################################################
  attr_accessible :name, :format

  validates_presence_of :name, :format

  has_many :card_in_deck, -> {order 'main_copies asc'}, :dependent => :destroy
  has_many :cards,        -> {order :name}, :through => :card_in_deck
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
  def validate
    reasons = []
    is_valid = true
    format = Format::FORMATS[self.format]

    # min cards
    unless format[:min_cards].nil?
      if self.main_count < format[:min_cards]
        is_valid = false
        reasons << {card: nil, msg: "Not enough cards in main deck (#{self.main_count})."}
      end
    end

    # max cards
    unless format[:max_cards].nil?
      if self.main_count > format[:max_cards]
        is_valid = false
        reasons << {card: nil, msg: "Too many cards in main deck (#{self.main_count})."}
      end
    end

    # sideboard size
    unless format[:sideboard_size].nil?
      if self.side_count != 0 && self.side_count != format[:sideboard_size]
        is_valid = false
        reasons << {card: nil, msg: "Sideboard does not have exactly #{format[:sideboard_size]} cards."}
      end
    end

    banned_cards = format[:banned_cards].nil? ? [] : format[:banned_cards]
    restricted_cards = format[:restricted_cards].nil? ? [] : format[:restricted_cards]

    self.card_in_deck.each do |cid|
      card = cid.card
      next if card.main_type == Card::CARD_TYPES[:basic_land]

      # Max copies of each card
      if (cid.main_copies > 4 || cid.side_copies > 4)
        is_valid = false
        reasons << {card: card, msg: "Too many copies."}
      end

      # legal editions
      unless format[:legal_editions].nil?
        is_legal = false
        card.editions.each do |e|
          if format[:legal_editions].include?(e.name)
            is_legal = true
            break
          end
        end

        unless is_legal
          is_valid = false
          reasons << {card: card, msg: "No legal edition."}
        end
      end

      # banned cards
      if banned_cards.include?(card.name)
        is_valid = false
        reasons << {card: card, msg: "Banned."}
      end

      # restricted cards -- can only have 1 copy in deck
      if restricted_cards.include?(card.name)
        if (cid.main_copies > 1 || cid.side_copies > 1)
          is_valid = false
          reasons << {card: card, msg: "Restricted. Too many copies."}
        end
      end

    end

    return (reasons)
  end
  ##############################################################################
  def stats
    stats = {
      :main_type => {},
      :color     => {
        :red        => 0,
        :green      => 0,
        :blue       => 0,
        :black      => 0,
        :white      => 0,
        :colorless  => 0
      },
      :cost => Array.new(7,0)
    };

    card_in_deck.each do |cid|
      next unless cid.main_copies > 0

      card = cid.card
      copies = cid.main_copies

      # Cost
      unless (card.is_land?)
        cost = card.converted_mana_cost
        cost = 6 if cost >= 6
        stats[:cost][cost] += copies
      end

      # Main Type
      if (stats[:main_type][card.main_type].nil?)
        stats[:main_type][card.main_type] = copies
      else
        stats[:main_type][card.main_type] += copies
      end

      # Color
      stats[:color][:red]       += copies if card.is_red?
      stats[:color][:green]     += copies if card.is_green?
      stats[:color][:blue]      += copies if card.is_blue?
      stats[:color][:black]     += copies if card.is_black?
      stats[:color][:white]     += copies if card.is_white?
      stats[:color][:colorless] += copies if card.is_colorless?

    end

    return (stats)
  end
  ##############################################################################
  def add_card(card, options = {:main_copies => 1, :side_copies => 0})
    card_in_deck = CardInDeck.new(
      :deck => self,
      :card => card,
      :main_copies => options[:main_copies],
      :side_copies => options[:side_copies] || 0
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
