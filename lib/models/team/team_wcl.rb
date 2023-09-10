module Audit
  class TeamWcl < Team

    def refresh
      return unless REALMS[guild.realm_id].kind == 'live'

      # Requests are not made in parallel, otherwise
      # load on the Warcraft Logs API would be too high
      characters.each do |character|
        VALID_RAIDS[:live].select{ |r| r['days'].include? Time.now.wday }.each do |zone|
          begin
            response = Typhoeus.get(uri(character, zone))
            character.process_result(response, zone)
            sleep 0.1
          rescue ApiLimitReachedException
            Logger.t(ERROR_API_LIMIT_REACHED, id)
            sleep 10
            retry
          end
        end
      end
      Logger.t(INFO_TEAM_REFRESHED, id)
      Writer.update_db(characters) if characters.any?
    end

    def uri(character, zone)
      realm = REALMS[character.realm_id || guild.realm_id]

      uri = WCL_URL[0 .. WCL_URL.length]
      uri["{region}"] = realm.region
      uri["{realm}"] = realm.wcl_name
      uri["{name}"] = character.name
      uri["{zone}"] = zone["id"].to_s
      uri["{metric}"] = character.wcl_role
      uri["{key}"] = KEY.client_id
      uri
    end

    def characters
      @characters ||= super(CharacterWcl.where(:team_id => id).to_a)
    end
  end
end
