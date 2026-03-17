module Wowaudit
  module Retrievers
    class Blizzard
      def self.retrieve(all_characters, output = {}, commit_changes = true)
        api_limited = []

        all_characters.group_by { |ch| ch.realm.namespace }.each do |namespace, characters|
          region = characters.first.realm.region
          Audit.timestamp = region
          RBattlenet.set_options(namespace: namespace, region: region, locale: (region == "US" ? "en_US" : "en_GB"), response_type: :hash)

          RBattlenet::Wow::Character.find(
            characters.map do |ch|
              {
                name: ch.name.downcase,
                realm: ch.realm.slug,
                season: Season.current.id,
                source: ch,
                timestamp: self.last_modified_for_character(ch),
              }
            end,
            fields: FIELDS[characters.first.realm.game_version.to_sym] + Wowaudit.extra_fields,
          ) do |character, response|
            begin
              output[character[:source]] = Wowaudit::Results::Blizzard.new(character[:source], response, commit_changes)
            rescue Wowaudit::Exception::ApiLimitReached
              api_limited << character[:source]
            rescue Wowaudit::Exception::CharacterUnavailable => error
              raise error unless Wowaudit.ignore_unavailable
            end
          end
        end

        if api_limited.any?
          raise Wowaudit::Exception::ApiLimitReached unless Wowaudit.retry_on_api_limit
          self.retrieve(api_limited, output, commit_changes)
        else
          output
        end
      end

      def self.retrieve_group(team_id)
        team = Team.where(id: team_id).first

        if team.characters.any?
          output = retrieve(team.characters.first(100), {}, false)
          Logger.t(INFO_TEAM_REFRESHED, team.id)

          section = {
            live: Live,
            classic_progression: ClassicProgression,
            classic_era: ClassicEra,
            classic_anniversary: ClassicAnniversary,
            tournament: ClassicEra,
          }[team.owner.realm.game_version.to_sym]

          Writer.write(team, output, section::HeaderData.altered_header(team))
          Writer.update_db(output, true)
          Wowaudit::Metadata.store_all(output)
        else
          Logger.t(INFO_TEAM_EMPTY, team.id)
        end
      end

      def self.last_modified_for_character(character)
        # Don't skip a character if the last refresh was made with an older version,
        # when the new week has started, or when the character's last refresh failed
        return 0 if character.details['current_version'] < CURRENT_VERSION[character.realm.game_version.to_sym]
        return 0 if character.details['current_period'] < Audit.period
        return 0 if character.status != "tracking"
        return 0 unless REGISTER # Don't skip in development
        return 0 if PREVENT_SKIP_TIMESTAMP.to_i > character.refreshed_at.to_i

        character.details.dig('last_refresh', 'blizzard_last_modified')
      end
    end
  end
end
