module Wowaudit
  module Retrievers
    class Raiderio
      def self.retrieve(all_characters, team_id)
        all_characters.map do |character|
          Audit.verify_details(character, character.details, character.realm)

          uri = RAIDER_IO_URL[0 .. RAIDER_IO_URL.length]
          uri["{realm}"] = CGI.escape(character.realm.slug)
          uri["{region}"] = character.realm.region
          uri["{name}"] = CGI.escape(character.name)

          begin
            response = Typhoeus.get(uri)
            Wowaudit::Metrics.record(response.code)
            Wowaudit::Results::Raiderio.new(character, response)
          rescue Wowaudit::Exception::ApiLimitReached
            Audit::Logger.t(ERROR_API_LIMIT_REACHED, team_id)
            sleep 5
            retry
          end
        end
      end

      def self.retrieve_group(team_id)
        team = Audit::Team.where(id: team_id).first
        return unless team && team.guild.realm.game_version == 'live'

        Audit.timestamp = team.guild.realm.region

        # Requests are not made in parallel, otherwise
        # load on the Warcraft Logs API would be too high
        output = self.retrieve(team.characters, team_id)

        Audit::Logger.t(INFO_TEAM_REFRESHED + "#{output.length} characters.", team_id)
        Wowaudit::Metadata.store_all(output) if output.any?
      end
    end
  end
end
