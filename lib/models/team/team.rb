module Audit
  class Team < Sequel::Model
    many_to_one :guild

    class << self
      def refresh(id, refresh_type)
        team = self.type(refresh_type).where(id: id).first
        return Logger.t(ERROR_TEAM_DELETED, id) unless team
        Audit.timestamp = REALMS[team.guild.realm_id].region
        team.refresh
      end

      def type(refresh_type)
        Audit.const_get("Team#{refresh_type.capitalize}")
      end
    end

    def characters(characters)
      characters.each_with_index do |character, index|
        character.realm_slug = Realm.to_slug(REALMS[character.realm_id || guild.realm_id])
        character.details = character_details[character.id].to_h
        character.verify_details
      end
      characters.select{ |character| character.active }
    end

    def character_details
      @character_details ||= Arango.get_characters_by_team(id)
    end

    def raids_path
      "https://wowaudit.com/raids/#{guild.path}/#{name.gsub(" ","-").downcase}"
    end

    def slugged_region
      case region
      when "US"
        return "en-us"
      when "TW"
        return "zh-tw"
      when "KR"
        return "ko-kr"
      else
        return "en-gb"
      end
    end
  end
end
