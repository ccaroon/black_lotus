class Edition < ActiveRecord::Base
  paginates_per 10

  attr_accessible :card_count, :code_name, :name, :online_code, :release_date
  has_and_belongs_to_many :cards, :order => :name
  ##############################################################################
  def self.recent_editions
    one_yr_ago = Time.now - 1.year
    re = Edition
      .where("release_date between :one_yr_ago and :now", {one_yr_ago: one_yr_ago, now: Time.now})
      .order('release_date')

    return re
  end

end
