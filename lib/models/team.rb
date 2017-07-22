module Audit
  class Team < Sequel::Model

    def refresh
      # Forked library, processing the result of each Character
      # is called from within the RBattlenet library
      RBattlenet.authenticate(api_key: BNET_KEY)
      RBattlenet.set_region(region: region, locale: "en_GB")
      Audit.timestamp = region
      $errors = { :tracking => 0, :role => 0 }
      result = RBattlenet::Wow::Character.find_all(characters,
        fields: ["items","reputation","audit","statistics","achievements","pets","pvp"])
      Logger.t(INFO_TEAM_REFRESHED, id)

      update_database(result.map { |uri, character| character })
      Writer.write(self, result, HeaderData.altered_header(self))
    end

    def update_database(result)
      # Sequel does not support saving multiple objects
      # in one single query, therefore the update query
      # is created manually to massively improve the speed

      # Update specialisation data
      query = "UPDATE characters SET per_spec = CASE "
      result.each do |character|
        query << "WHEN id = #{character.id} THEN '#{character.per_spec}' "
      end

      # Store entire output in case the next cycle fails for a character
      query << " ELSE per_spec END, last_refresh = CASE "
      result.each do |character|
        output = JSON.generate character.output ##{output.gsub(/'/) {|s| "\\'"}}
        query << "WHEN id = #{character.id} THEN last_refresh "
      end

      changed_characters = result.select{ |c| c.changed }
      if changed_characters.any?
        # Update the tracking status for changed characters
        query << " ELSE last_refresh END, status = CASE "
        changed_characters.each do |character|
          query << "WHEN id = #{character.id} THEN '#{character.status}' "
        end

        # Update the owned Legendaries for changed characters
        query << " ELSE status END, legendaries = CASE "
        changed_characters.each do |character|
          query << "WHEN id = #{character.id} THEN '#{character.legendaries.gsub(/'/) {|s| "\\'"}}' "
        end

        # Update the weekly snapshot for changed characters
        query << " ELSE legendaries END, weekly_snapshot = CASE "
        changed_characters.each do |character|
          query << "WHEN id = #{character.id} THEN '#{character.weekly_snapshot}' "
        end

        # Update the historical snapshots for changed characters
        query << " ELSE weekly_snapshot END, old_snapshots = CASE "
        changed_characters.each do |character|
          query << "WHEN id = #{character.id} THEN '#{character.old_snapshots}' "
        end

        # Update the owned tier pieces data for changed characters
        query << " ELSE old_snapshots END, tier_data = CASE "
        changed_characters.each do |character|
          query << "WHEN id = #{character.id} THEN '#{character.tier_data}' "
        end
        query << " ELSE tier_data END"
      else
        query << " ELSE last_refresh END"
      end

      DB2.query(query, :async => true)
      Logger.t(INFO_TEAM_UPDATED +
        "Updated additional data for #{changed_characters.length} characters", id)
    end

    def characters
      @characters ||= Character.where(:team_id => id).to_a
      @characters.each_with_index do |character, index|
        @characters[index].realm = character.realm.to_s.empty? ? realm : character.realm
      end

      @characters
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

    def warning
      if $errors[:tracking] > 0
        TRACK_WARNING
      elsif $errors[:role] > 0
        ROLE_WARNING
      else
        NO_WARNING
      end
    end
  end
end
