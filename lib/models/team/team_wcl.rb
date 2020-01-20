module Audit
  class TeamWcl < Team

    def refresh
      # Requests are not made in parallel, otherwise
      # load on the Warcraft Logs API would be too high
      characters.each do |character|
        VALID_RAIDS.select{ |r| r['days'].include? Time.now.wday }.each do |zone|
          begin
            response = Typhoeus.get(uri(character, zone))
            character.process_result(response)
          rescue ApiLimitReachedException
            Logger.t(ERROR_API_LIMIT_REACHED, id)
            sleep 10
            retry
          end
        end
      end
      Logger.t(INFO_TEAM_REFRESHED, id)
      Writer.update_db(characters)
    end

    def uri(character, zone)
      uri = WCL_URL[0 .. WCL_URL.length]
      uri["{region}"] = region
      uri["{realm}"] = REALMS[character.realm_id || guild.realm_id].wcl_name
      uri["{name}"] = character.name
      uri["{zone}"] = zone["id"].to_s
      uri["{metric}"] = character.wcl_role
      uri
    end

    def characters
      @characters ||= super(CharacterWcl.eager(:realm).where(:team_id => id).to_a)
    end
  end
end
