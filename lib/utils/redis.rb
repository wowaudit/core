module Audit
  module Redis
    def self.get_characters(ids)
      return {} unless ids.any?
      REDIS.mget(*ids).map.with_index do |data, i|
        [ids[i], data ? Oj.load(data) : {}]
      end.to_h
    end

    def self.update(entries)
      return if entries.empty?

      payload = if entries.is_a?(Hash)
        entries.map { |key, value| [key, value.is_a?(String) ? value : value.to_json] }.flatten
      else
        entries.map { |character| [character.redis_id, character.metadata.to_json] }.flatten
      end

      REDIS.mset(payload)
    end
  end
end
