module Wowaudit
  module Retrievers
    class Wcl
      def self.retrieve(all_characters, team_id)
        all_characters.map do |character|
          responses = VALID_RAIDS[:live].select{ |r| r['days'].include? Time.now.wday }.map do |zone|
            begin
              sleep 0.1
              { zone: zone, response: Typhoeus.get(self.uri(character, zone)) }
            rescue Wowaudit::Exception::ApiLimitReached
              Audit::Logger.t(ERROR_API_LIMIT_REACHED, team_id)
              sleep 10
              retry
            end
          end

          Wowaudit::Results::Wcl.new(character, responses)
        end
      end

      def self.retrieve_group(team_id)
        team = Audit::Team.where(id: team_id).first

        return unless team.guild.realm.game_version == 'live'

        # Requests are not made in parallel, otherwise
        # load on the Warcraft Logs API would be too high
        output = self.retrieve(team.characters, team_id)

        Audit::Logger.t(INFO_TEAM_REFRESHED, team_id)
        Wowaudit::Metadata.store_all(output) if output.any?
      end

      def self.uri(character, zone)
        uri = WCL_URL[0 .. WCL_URL.length]
        uri["{region}"] = character.realm.region.downcase
        uri["{realm}"] = character.realm.slug
        uri["{name}"] = character.name
        uri["{zone}"] = zone["id"].to_s
        uri["{metric}"] = 'dps'
        uri["{key}"] = WCL_CLIENT_ID
        uri
      end
    end
  end
end
