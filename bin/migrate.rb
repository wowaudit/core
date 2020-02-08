REGISTER = false
TYPE = "migrate"
require_relative('../lib/core')

def migrate
  Audit::Character.exclude(key: nil).to_a.each_slice(1000) do |characters|
    puts "Migrating characters... First id: #{characters.first.key}"
    puts "Fetching arango data"
    arango_data = Audit::Arango.get_characters(characters.map(&:id))
    puts "Storing in redis"
    REDIS.mset characters.map{ |character| ["character:#{character.key}", arango_data[character.id].to_json] }.flatten
    puts "Finished storing in redis"
  end
end

migrate
