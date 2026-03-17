module Wowaudit
  module Retrievers
    class Wcl
      def self.retrieve(all_characters)
        all_characters.map do |character|
          responses = VALID_RAIDS[:live].select{ |r| r['days'].include? Time.now.wday }.map do |zone|
            begin
              { zone: zone, response: Typhoeus.get(self.uri(character, zone)) }
              sleep 0.1
            rescue Wowaudit::Exception::ApiLimitReached
              Logger.t(ERROR_API_LIMIT_REACHED, id)
              sleep 10
              retry
            end
          end

          Wowaudit::Results::Wcl.new(character, responses)
        end
      end

      def self.retrieve_group(team_id)
        team = Team.where(id: team_id).first

        return unless team.owner.realm.kind == 'live'

        # Requests are not made in parallel, otherwise
        # load on the Warcraft Logs API would be too high
        output = self.retrieve(team.characters, {}, false)

        Logger.t(INFO_TEAM_REFRESHED, id)
        Wowaudit::Metadata.store_all(output) if output.any?
      end

      def uri(character, zone)
        uri = WCL_URL[0 .. WCL_URL.length]
        uri["{region}"] = character.realm.region
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
