# encoding: utf-8
require 'httmultiparty'
require 'utility'

class HanDBaseSync
  # include HTTMultiParty
  # base_uri "http://magiccards.info"
  ##############################################################################
  def self.sync_db(host)
    file_name = Utility.export_cards

    r = HTTMultiParty.post("http://#{host}/applet_add.html", :query => {
      :localfile  => File.new(file_name),
      :appletname => "Magic Cards"
    })
    raise r.message unless r.code == 200
  end

end
