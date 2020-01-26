module Audit
  class TeamRaiderio < Team

    def refresh
      characters.each do |character|
        realm = REALMS[character.realm_id || guild.realm_id]
        uri = RAIDER_IO_URL[0 .. RAIDER_IO_URL.length]
        uri["{realm}"] = CGI.escape(realm.blizzard_name)
        uri["{region}"] = realm.region
        uri["{name}"] = CGI.escape(character.name)

        begin
          character.process_result(Typhoeus.get(uri))
        rescue ApiLimitReachedException
          Logger.t(ERROR_API_LIMIT_REACHED, id)
          sleep 5
          retry
        end
      end

      Logger.t(INFO_TEAM_REFRESHED, id)
      Writer.update_db(characters)
    end

    def characters
      @characters ||= super(CharacterRaiderio.where(:team_id => id).to_a)
    end
  end
end
