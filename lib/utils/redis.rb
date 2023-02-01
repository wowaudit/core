module Audit
  module Redis
    def self.get_characters(ids)
      return {} unless ids.any?
      REDIS.mget(*ids).map.with_index do |data, i|
        [ids[i], data ? Oj.load(data) : {}]
      end.to_h
    end

    def self.update(characters)
      if characters.any?
        REDIS.mset characters.map{ |character| [character.redis_id, character.metadata.to_json] }.flatten
      end
    end
  end
end
