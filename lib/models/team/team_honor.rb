module Audit
  class TeamHonor < Team

    def refresh
      # Requests are not made in parallel, as we're not accessing
      # a proper API we don't want the load to be too high.
      characters.each do |character|
        response = Typhoeus.get(uri(character))
        character.process_result(response)
      end
      Logger.t(INFO_TEAM_REFRESHED, id)
      Writer.update_db(characters)
    end

    def uri(character)
      uri = HONOR_URL[0 .. HONOR_URL.length]
      uri["{region}"] = slugged_region
      uri["{realm}"] = Realm.to_slug(character.realm || realm)
      uri["{name}"] = CGI.escape(character.name)
      uri
    end

    def characters
      @characters ||= super(CharacterHonor.where(:team_id => id).to_a)
    end
  end
end
