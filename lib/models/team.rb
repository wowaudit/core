module Audit
  class Team < Sequel::Model

    def refresh
      # Forked library, processing the result of each Character
      # is called from within the RBattlenet library
      RBattlenet.authenticate(api_key: BNET_KEY)
      RBattlenet.set_region(region: region, locale: "en_GB")
      Audit.timestamp = region
      result = RBattlenet::Wow::Character.find_all(characters,
        fields: ["items","reputation","audit","statistics","achievements","pets","pvp"])

      DB.transaction do
        result.each do |uri, character|
          #character.save
        end
      end
      Writer.write(self, result)
    end

    def characters
      @characters ||= Character.where(:team_id => id).to_a
      @characters.each_with_index do |character, index|
        @characters[index].realm = character.realm.empty? ? realm : character.realm
      end

      @characters
    end

    def realm
      @realm ||= Guild.where(:id => guild_id).first.realm
    end

    def region
      @region ||= Guild.where(:id => guild_id).first.region
    end
  end
end
