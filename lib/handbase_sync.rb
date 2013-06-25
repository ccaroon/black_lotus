# encoding: utf-8
# require 'httmultiparty'
require 'net/http/post/multipart'
require 'utility'

class HanDBaseSync
  # include HTTMultiParty
  # base_uri "http://magiccards.info"
  ##############################################################################
  def self.sync_db(host)
    file_name = Utility.export_cards

    r = nil
    url = URI.parse("http://#{host}:8080/applet_add.html")
    File.open(file_name) do |csv_file|
      req = Net::HTTP::Post::Multipart.new(
        url.path,
        :appletname => "Magic Cards",
        :localfile  => UploadIO.new(csv_file, "text/csv", "export.csv")
      )
      r = Net::HTTP.start(url.host, url.port) do |http|
        http.request(req)
      end
    end

    # r = HTTMultiParty.post("http://#{host}:8080/applet_add.html", :query => {
    #   :localfile  => File.new(file_name),
    #   :appletname => "Magic Cards"
    # })

    File.delete(file_name)

    raise "#{r.message} - (#{r.code})" unless r.code.to_i < 400
  end

end
