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
        character.realm_slug = REALMS[character.realm_id || guild.realm_id].blizzard_name
        character.details = character_details(characters)[character.redis_id].to_h
        character.verify_details
      end
      characters.select(&:active)
    end

    def character_details(characters)
      @character_details ||= Redis.get_characters(characters.map(&:redis_id).compact)
    end

    def raids_path
      "https://wowaudit.com/#{guild.path}/#{name.gsub(" ","-").downcase}/raids"
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
