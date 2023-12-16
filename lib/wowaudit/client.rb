module Wowaudit
  class Client
    def initialize(client_id, client_secret)
      authenticate(client_id, client_secret)
      RBattlenet.set_options(concurrency: 25, timeout: 5, retries: 5, response_type: :hash)
    end

    def retrieve(characters, output = {})
      api_limited = []

      characters.group_by(&:namespace).each do |namespace, characters|
        region = characters.first.region
        Audit.timestamp = region
        RBattlenet.set_options(namespace: namespace, region: region, locale: (region == "US" ? "en_US" : "en_GB"))

        RBattlenet::Wow::Character.find(
          characters.map do |ch|
            {
              name: ch.name.downcase,
              realm: ch.realm.slug,
              season: CURRENT_KEYSTONE_SEASON,
              source: ch
            }
          end, fields: (Wowaudit.extended ? FIELDS[:live] : [:equipment]) + Wowaudit.extra_fields
        ) do |character, response|
          begin
            output[character[:source]] = Wowaudit::Result.new(character[:source], response)
          rescue Wowaudit::Exception::ApiLimitReached
            api_limited << character[:source]
          rescue Wowaudit::Exception::CharacterUnavailable => error
            raise error unless Wowaudit.ignore_unavailable
          end
        end
      end

      if api_limited.any?
        raise Wowaudit::Exception::ApiLimitReached unless Wowaudit.retry_on_api_limit
        retrieve(api_limited, output)
      else
        output
      end
    end

    def authenticate(client_id, client_secret)
      attempts = 0
      begin
        RBattlenet.authenticate(client_id: client_id, client_secret: client_secret)
      rescue
        attempts += 1
        if attempts < 5
          retry
        else
          raise
        end
      end

      @authenticated_at = DateTime.now
    end
  end
end
