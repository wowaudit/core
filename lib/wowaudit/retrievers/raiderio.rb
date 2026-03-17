module Wowaudit
  module Retrievers
    class Raiderio
      def self.retrieve(all_characters)
        all_characters.map do |character|
          uri = RAIDER_IO_URL[0 .. RAIDER_IO_URL.length]
          uri["{realm}"] = CGI.escape(character.realm.slug)
          uri["{region}"] = character.realm.region
          uri["{name}"] = CGI.escape(character.name)

          begin
            Wowaudit::Results::Raiderio.new(character, Typhoeus.get(uri))
          rescue Wowaudit::Exception::ApiLimitReached
            Logger.t(ERROR_API_LIMIT_REACHED, id)
            sleep 5
            retry
          end
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
    end
  end
end
