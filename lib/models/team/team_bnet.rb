module Audit
  class TeamBnet < Team

    def refresh
      # Forked library, processing the result of each Character
      # is called from within the RBattlenet library
      RBattlenet.authenticate(api_key: BNET_KEY)
      RBattlenet.set_region(region: region, locale: "en_GB")
      Audit.timestamp = region
      $errors = { :tracking => 0, :role => 0 }
      result = RBattlenet::Wow::Character.find_all(characters,
        fields: ["items","reputation","audit","statistics","achievements","pets","pvp"])
      Logger.t(INFO_TEAM_REFRESHED, id)

      Writer.update_db(result.map { |uri, character| character }, id)
      Writer.write(self, result, HeaderData.altered_header(self))
    end

    def characters
      @characters ||= super(CharacterBnet.where(:team_id => id).to_a)
    end

    def warning
      if $errors[:tracking] > 0
        TRACK_WARNING
      elsif $errors[:role] > 0
        ROLE_WARNING
      else
        NO_WARNING
      end
    end
  end
end
