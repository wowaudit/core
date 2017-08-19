module Audit
  class TeamRaiderio < Team

    def refresh
      hydra = Typhoeus::Hydra.new
      characters.each do |character|
        uri = RAIDER_IO_URL[0 .. RAIDER_IO_URL.length]
        uri["{region}"] = region
        uri["{realm}"] = character.realm || Realm.to_slug(realm)
        uri["{name}"] = CGI.escape(character.name)
        request = Typhoeus::Request.new(uri)
        request.on_complete do |response|
          character.process_result(response)
        end
        hydra.queue(request)
      end

      hydra.run
      Logger.t(INFO_TEAM_REFRESHED, id)
      Writer.update_db_raiderio(characters)
    end

    def characters
      @characters ||= super(CharacterRaiderio.where(:team_id => id).to_a)
    end
  end
end
