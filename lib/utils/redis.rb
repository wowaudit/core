module Audit
  module Redis
    def self.get_characters(ids)
      return {} unless ids.any?
      REDIS.mget(*ids.map{ |id| "character:#{id}" }).map.with_index{ |data, i| [ids[i], JSON.parse(data)] }.to_h
    end

    def self.update(characters)
      if characters.any?
        REDIS.mset characters.map{ |character| ["character:#{character.key}", character.details.to_json] }.flatten
      end
    end
  end
end
