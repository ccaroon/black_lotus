class Edition < ActiveRecord::Base
  paginates_per 10

  validates_presence_of :name, :code_name, :release_date, :card_count
  validates_numericality_of :card_count, 
    :only_integer => true, :greater_than => 0

  attr_accessible :card_count, :code_name, :name, :online_code, :release_date
  has_and_belongs_to_many :cards, :order => :name
  ##############################################################################
  def self.recent_editions
    yrs_ago = Time.now - 2.year
    re = Edition
      .where("release_date between :yrs_ago and :now", {yrs_ago: yrs_ago, now: Time.now})
      .order('release_date')

    return re
  end

end
