module Audit
  class TeamWcl < Team

    def refresh
      Audit.timestamp = region
      # Requests are not made in parallel, otherwise
      # load on the Warcraft Logs API would be too high
      characters.each do |character|
        VALID_RAIDS.select{ |r| r['days'].include? Time.now.wday }.each do |zone|
          response = Typhoeus.get(uri(character, zone))
          character.process_result(response)
        end
      end
      Logger.t(INFO_TEAM_REFRESHED, id)
      Writer.update_db(characters)
    end

    def uri(character, zone)
      uri = WCL_URL[0 .. WCL_URL.length]
      uri["{region}"] = region
      uri["{realm}"] = Realm.wcl_realm(character.realm || realm)
      uri["{name}"] = character.name
      uri["{zone}"] = zone["id"].to_s
      uri["{metric}"] = character.wcl_role
      uri["{partition}"] = zone["partition"].to_s
      uri
    end

    def characters
      @characters ||= super(CharacterWcl.where(:team_id => id).to_a)
    end
  end
end
