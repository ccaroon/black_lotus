class Edition < ActiveRecord::Base
  attr_accessible :card_count, :code_name, :name, :online_code, :release_date
  has_and_belongs_to_many :cards
end
