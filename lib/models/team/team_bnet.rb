module Audit
  class TeamBnet < Team

    def refresh
      RBattlenet.set_options(region: REALMS[guild.realm_id].region, locale: "en_GB", concurrency: 50, response_type: :hash)
      $errors = { :tracking => 0, :role => 0 }
      if guild.api_key && guild.api_key.active
        begin
          Audit.authenticate(guild.api_key.client_id, guild.api_key.client_secret)
        rescue RBattlenet::Errors::Unauthorized
          raise if TYPE.include?("dedicated")
          guild.api_key.update(active: false)
        end
      end

      if characters.any?
        output = process_request(characters)
        Logger.t(INFO_TEAM_REFRESHED, id)

        Writer.write(self, output.reject(&:marked_for_deletion_at), HeaderData.altered_header(self))
        Writer.update_db(output, true)
      else
        Logger.t(INFO_TEAM_EMPTY, id)
      end

      if guild.api_key && guild.api_key.active && defined?(KEY)
        Audit.authenticate(KEY.client_id, KEY.client_secret)
      end
    end

    def process_request(characters, output = [])
      api_limited = []

      result = RBattlenet::Wow::Character.find(
        characters.map{ |ch| { name: ch.name.downcase, realm: ch.realm_slug, source: ch } }, fields: self.class::FIELDS
      ) do |character, result|
        begin
          if character[:source].process_result(result)
            output << character[:source]
          end
        rescue ApiLimitReachedException
          api_limited << character[:source]
        end
      end

      if api_limited.any?
        Logger.t(INFO_TEAM_RETRYING_API_LIMITED + api_limited.map(&:id).join(', '), id)
        process_request(api_limited, output)
      else
        output
      end
    end

    def warning
      if guild.days_remaining <= 7
        INACTIVE_WARNING
      elsif $errors[:tracking] > 0
        TRACK_WARNING
      else
        NO_WARNING
      end
    end
  end
end
