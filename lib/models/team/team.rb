module Audit
  class Team < Sequel::Model
    class << self
      def refresh(id, type)
        self.type(type).where(id: id).first.refresh
      end

      def type(type)
        type == "bnet" ? TeamBnet : (type == "raiderio" ? TeamRaiderio : TeamWcl)
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

    def guild_name
      guild_data("name")
    end

    def realm
      guild_data("realm")
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
