module Audit
  module Redis
    def self.get_characters(ids)
      return {} unless ids.any?
      REDIS.mget(*ids.map{ |id| "slcharacter:#{id}" }).map.with_index do |data, i|
        [ids[i], data ? JSON.parse(data) : {}]
      end.to_h
    end

    def self.update(characters)
      if characters.any?
        REDIS.mset characters.map{ |character| ["slcharacter:#{character.key}", character.metadata.to_json] }.flatten
      end
    end
  end
end
