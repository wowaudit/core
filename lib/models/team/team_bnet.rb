module Audit
  class TeamBnet < Team

    def refresh
      Audit.timestamp = region
      # Forked library, processing the result of each Character
      # is called from within the RBattlenet library
      RBattlenet.authenticate(api_key: BNET_KEY)
      RBattlenet.set_region(region: region, locale: "en_GB")
      $errors = { :tracking => 0, :role => 0 }
      if characters.any?
        result = RBattlenet::Wow::Character.find_all(characters,
          fields: BNET_FIELDS)
        Logger.t(INFO_TEAM_REFRESHED, id)

        Writer.write(self, result, HeaderData.altered_header(self))
        Writer.update_db(result.map { |uri, character| character }, true)
      else
        Logger.t(INFO_TEAM_EMPTY, id)
      end
    end

    def characters
      @characters ||= super(CharacterBnet.where(:team_id => id).to_a)
    end

    def warning
      if days_remaining <= 7
        INACTIVE_WARNING
      elsif $errors[:tracking] > 0
        TRACK_WARNING
      elsif $errors[:role] > 0
        ROLE_WARNING
      else
        NO_WARNING
      end
    end
  end
end
