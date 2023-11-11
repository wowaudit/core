module Audit
  class TeamBlizzard < Team
    FIELDS = {
      live: [
        :achievements,
        :achievement_statistics,
        :completed_quests,
        :equipment,
        :mounts, # Only needed to track Mythic raid mounts, when relevant
        :pets,
        :professions,
        :pvp_bracket_2v2,
        :pvp_bracket_3v3,
        :pvp_bracket_rbg,
        :pvp_summary,
        :season_keystones,
        :reputations,
        :status,
        :titles,
      ],
      classic_era: [
        :equipment,
        :pvp_summary,
        :status,
      ],
      classic_progression: [
        :status,
      ]
    }

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

        # Writer.write(self, output.reject(&:marked_for_deletion_at), HeaderData.altered_header(self))
        Writer.write(self, output, REALMS[guild.realm_id].section::HeaderData.altered_header(self))
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
        characters.map{ |ch| character_query(ch) }, fields: self.class::FIELDS[REALMS[guild.realm_id].kind.to_sym]
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
