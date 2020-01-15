module Audit
  class TeamBnet < Team

    def refresh
      # Forked library, processing the result of each Character
      # is called from within the RBattlenet library
      RBattlenet.set_options(region: region, locale: "en_GB")
      $errors = { :tracking => 0, :role => 0 }
      output = []

      if characters.any?
        result = RBattlenet::Wow::Character.find(
          characters.map{ |ch| { name: ch.name.downcase, realm: ch.realm_slug, source: ch } },
          fields: [:equipment, :legacy]
        ) do |character, result|
          character[:source].process_result(result)
          output << character[:source]
        end
        Logger.t(INFO_TEAM_REFRESHED, id)

        Writer.write(self, output, HeaderData.altered_header(self))
        Writer.update_db(output, true)
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
      else
        NO_WARNING
      end
    end
  end
end
