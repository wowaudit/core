require_relative('audit')

#Typhoeus
time = Time.now
RBattlenet.authenticate(api_key: BNET_KEY)
RBattlenet.set_region(region: "eu", locale: "en_GB")
data = RBattlenet::Wow::Character.find_all(Audit::Team.find(1).first.characters)
puts "Typhoeus took #{Time.now - time} seconds"

#HTTParty
# time = Time.now
# RBattlenet.authenticate(api_key: BNET_KEY)
# RBattlenet.set_region(region: "eu", locale: "en_GB")
# Audit::Team.find(1).first.characters.each do |character|
#   character = RBattlenet::Wow::Character.find(name: character.name, realm: character.realm)
#   puts character
#   sleep(0.1)
# end
# puts "HTTParty took #{Time.now - time} seconds"
