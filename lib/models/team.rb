module Audit
  class Team < Sequel::Model

    def refresh
      # Forked library, processing the result of each Character
      # is called from within the RBattlenet library
      RBattlenet.authenticate(api_key: BNET_KEY)
      RBattlenet.set_region(region: region, locale: "en_GB")
      result = RBattlenet::Wow::Character.find_all(characters,
        fields: ["items","reputation","audit","statistics","achievements","pets","pvp"])
      Writer.write(self, result)
    end

    def characters
      @characters ||= Character.where(:team_id => id)
    end

    def region
      @region ||= Guild.where(:id => guild_id).first.region
    end
  end
end
