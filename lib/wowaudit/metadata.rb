module Wowaudit
  class Metadata
    class << self
      def client
        @@client ||= REDIS || Redis.new(
          url: "#{ENV['REDIS_HOST']}/#{Wowaudit.redis_suffix}",
          password: ENV['REDIS_PASSWORD']
        )
      end

      def store(result)
        client.set(result.character.redis_id, result.metadata.to_json)
      end

      def store_all(results)
        client.mset(results.map{ |result| [result.character.redis_id, result.metadata.to_json] }.flatten)
      end
    end
  end
end
