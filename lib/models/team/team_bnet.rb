module Audit
  class TeamBnet < Team

    def refresh
      RBattlenet.set_options(region: REALMS[guild.realm_id].region, locale: "en_GB", concurrency: 50)
      $errors = { :tracking => 0, :role => 0 }
      output = []
      if guild.api_key && guild.api_key.active
        begin
          RBattlenet.authenticate(
            client_id: guild.api_key.client_id,
            client_secret: guild.api_key.client_secret
          )
        rescue RBattlenet::Errors::Unauthorized
          guild.api_key.update(active: false)
        end
      end

      if characters.any?
        result = RBattlenet::Wow::Character.find(
          characters.map{ |ch| { name: ch.name.downcase, realm: ch.realm_slug, source: ch } }, fields: self.class::FIELDS
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

      if guild.api_key && guild.api_key.active
        RBattlenet.authenticate(client_id: KEY.client_id, client_secret: KEY.client_secret)
      end
    end

    def warning
      if guild.days_remaining <= 7
        INACTIVE_WARNING
      elsif $errors[:tracking] > 0
        TRACK_WARNING
      else
        NO_WARNING
      end
    end
  end
end
