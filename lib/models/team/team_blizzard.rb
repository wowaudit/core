module Audit
  class TeamBlizzard < Team
    def refresh(authentication_attempt = 0)
      RBattlenet.set_options(region: REALMS[guild.realm_id].region, namespace: REALMS[guild.realm_id].namespace, locale: "en_GB", concurrency: 25, timeout: 60, retries: 5, response_type: :hash, eager_children: true)
      $errors = { :tracking => 0, :role => 0 }
      if guild.api_key && guild.api_key.active
        begin
          Audit.authenticate(guild.api_key.client_id, guild.api_key.client_secret)
        rescue JSON::ParserError => e
          if authentication_attempt < 5
            return refresh(authentication_attempt + 1)
          else
            raise e
          end
        rescue RBattlenet::Errors::Unauthorized
          raise if TYPE.include?("dedicated")
          guild.api_key.update(active: false)
        end
      end

      if characters.any?
        output = process_request(characters)
        Logger.t(INFO_TEAM_REFRESHED, id)

        section = {
          live: Live,
          classic_progression: ClassicProgression,
          classic_era: ClassicEra,
          tournament: ClassicEra,
        }[REALMS[guild.realm_id].kind.to_sym]

        # Writer.write(self, output.reject(&:marked_for_deletion_at), HeaderData.altered_header(self))
        Writer.write(self, output, section::HeaderData.altered_header(self))
        Writer.update_db(output, true)
      else
        Logger.t(INFO_TEAM_EMPTY, id)
      end

      if guild.api_key && guild.api_key.active && defined?(KEY)
        Audit.authenticate(KEY.client_id, KEY.client_secret)
      end
    end

    def process_request(characters, output = [], depth = 0)
      api_limited = []

      RBattlenet::Wow::Character.find(
        characters.map{ |ch| character_query(ch) }, fields: FIELDS[REALMS[guild.realm_id].kind.to_sym]
      ) do |character, result|
        begin
          if character[:source].process_result(result, character[:skipped], depth)
            output << character[:source]
          end
        rescue ApiLimitReachedException, TimeoutsEncounteredException => err
          api_limited << character[:source]
        end
      end

      if api_limited.any?
        Logger.t(INFO_TEAM_RETRYING_API_LIMITED + api_limited.map(&:id).join(', '), id)
        process_request(api_limited, output, depth + 1)
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

    def characters
      @characters ||= super(CharacterBlizzard.where(:team_id => id).to_a)
    end

    def character_query(character)
      {
        name: character.name.downcase,
        realm: character.realm_slug,
        season: CURRENT_KEYSTONE_SEASON,
        source: character,
        timestamp: character.last_modified(self)
      }
    end
  end
end
