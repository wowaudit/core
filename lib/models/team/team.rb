module Audit
  class Team < Sequel::Model
    class << self
      def refresh(id, refresh_type)
        team = self.type(refresh_type).where(id: id).first
        Audit.timestamp = team.region
        team.refresh
      end

      def type(refresh_type)
        Audit.const_get("Team#{refresh_type.capitalize}")
      end
    end

    def characters(characters)
      characters.each_with_index do |character, index|
        character.realm = character.realm.to_s.empty? ? realm : character.realm
        character.details = character_details[character.id].to_h
        character.verify_details
      end
      characters.select{ |character| character.active }
    end

    def character_details
      @character_details ||= Arango.get_characters(id)
    end

    def guild_data(type)
      @guild_data ||= Guild.where(:id => guild_id).first
      @guild_data.send(type)
    end

    def raids_path
      "https://wowaudit.com/raids/#{guild_data("path")}/#{name.gsub(" ","-").downcase}"
    end

    def guild_name
      guild_data("name")
    end

    def realm
      guild_data("realm")
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

    def region
      guild_data("region")
    end

    def patreon
      guild_data("patreon")
    end

    def days_remaining
      guild_data("days_remaining")
    end
  end
end
