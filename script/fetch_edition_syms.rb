require 'httparty'
require 'edition'

def get_symbol(name)
  url = "http://www.wizards.com/Magic/Images/Expsym/exp_sym_#{name}_C.gif"
  r = HTTParty.get(url)
end

Edition.all.to_a.each do |edition|

  next if File.exists? "#{Rails.root}/app/assets/images/editions/#{edition.code_name}.gif"

  long_name = edition.name.downcase
  long_name.gsub!(/\s+/, '')

  resp = nil
  [edition.code_name, long_name].each do |sym|
    resp = get_symbol(sym)
    if resp.code == 200
      found = true
      break
    else
      puts "#{sym} -- #{resp.message}"
    end
  end

  next unless resp.code == 200

  File.open( "#{Rails.root}/app/assets/images/editions/#{edition.code_name}.gif", "wb") do |img|
    img << resp.body
  end

end

