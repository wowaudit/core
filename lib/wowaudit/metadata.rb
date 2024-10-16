module Wowaudit
  class Metadata
    class << self
      def client
        @@client ||= Redis.new(
          url: ENV['REDIS_HOST'],
          password: ENV['REDIS_PASSWORD']
        )
      end

      def store(result)
        client.set(result.character.redis_id, result.metadata.to_json)
      end
    end
  end
end
