module Audit
  module Writer

    def self.write(team, result, header)
      file = STORAGE.bucket(BUCKET).object("#{team.key_code}.csv")
      data = CSV.generate do |csv|
        csv << header
        result.sort_by{|c| c[1].name}.each do |uri, character|
          csv << character.output
        end
      end
      file.put(body: data)
      Logger.t(INFO_TEAM_WRITTEN, team.id)
    end

    def self.update_db(result, team_id)
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
        output = JSON.generate character.output
        query << "WHEN id = #{character.id} THEN #{self.escape(output)} "
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
          query << "WHEN id = #{character.id} THEN '#{self.escape(character.legendaries)}' "
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

      self.query(query)
      Logger.t(INFO_TEAM_UPDATED +
        "Updated additional data for #{changed_characters.length} characters", team_id)
    end

    def self.update_db_raiderio(characters)
      query = "UPDATE characters SET raiderio = CASE "
      characters.each do |character|
        query << "WHEN id = #{character.id} THEN '#{JSON.generate character.raiderio}' " if character.changed
      end

      query << " ELSE raiderio END, raiderio_weekly = CASE "
      characters.each do |character|
        query << "WHEN id = #{character.id} THEN #{character.raiderio_weekly} " if character.changed
      end
      query << " ELSE raiderio_weekly END"

      self.query(query)
      Logger.g(INFO_TEAM_UPDATED +
        "Updated Raider.io data for #{characters.length} characters")
    end

    def self.update_db_wcl(output, characters)
      query = "UPDATE characters SET warcraftlogs = CASE "
      characters.each do |character|
        query << "WHEN id = #{character.id} THEN '#{JSON.generate output[character.id]}' "
      end
      query << " ELSE warcraftlogs END"

      self.query(query)
      Logger.g(INFO_TEAM_UPDATED +
        "Updated Warcraft Logs data for #{characters.length} characters")
    end

    def self.query(query, async = true)
      # Await completion of the previous async query
      DB2.async_result

      DB2.query(query, :async => async)
    end

    def self.escape(string)
      string.gsub(/'/) {|s| "\\'"}
    end
  end
end
