module Audit
  module Redis
    def self.get_characters(ids)
      REDIS.mget(*ids.map{ |id| "character:#{id}" }).map.with_index{ |data, i| [ids[i], JSON.parse(data)] }.to_h
    end

    def self.update(characters)
      REDIS.mset characters.map{ |character| ["character:#{character.key}", character.details.to_json] }.flatten
    end
  end
end
