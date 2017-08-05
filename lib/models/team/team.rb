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
        characters[index].realm = character.realm.to_s.empty? ? realm : character.realm
      end
      characters.select{ |character| character.active }
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
  end
end
