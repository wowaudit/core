module Audit
  class Team < Sequel::Model
    many_to_one :guild
    one_to_many :team_ranks

    class << self
      def refresh(id, refresh_type)
        team = self.type(refresh_type).where(id: id).first
        return Logger.t(ERROR_TEAM_DELETED, id) unless team
        Audit.timestamp = REALMS[team.guild.realm_id].region
        team.refresh
      end

      def type(refresh_type)
        if refresh_type.include? "collections"
          TeamBlizzard
        else
          Audit.const_get("Team#{refresh_type.capitalize}")
        end
      end
    end

    def characters(characters)
      characters.each_with_index do |character, index|
        character.team_rank = ranks_by_id[character.team_rank_id]
        character.realm_slug = REALMS[character.realm_id || guild.realm_id].blizzard_name
        character.details = character_details(characters)[character.redis_id].to_h
        Audit.verify_details(character, character.details, REALMS[character.realm_id])
      end
      characters.select(&:active)
    end

    def character_details(characters)
      @character_details ||= Redis.get_characters(characters.map(&:redis_id).compact)
    end

    def ranks_by_id
      @ranks ||= team_ranks.group_by(&:id).transform_values(&:first)
    end

    def raids_path
      "https://wowaudit.com/#{guild.path}/#{name.gsub(" ","-").downcase}/raids"
    end

    def roster_path
      "https://wowaudit.com/#{guild.path}/#{name.gsub(" ","-").downcase}/roster"
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
