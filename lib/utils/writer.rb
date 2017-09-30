module Audit
  module Writer

    def self.write(team, result, header)
      file = STORAGE.bucket(BUCKET).object("#{team.key_code}.csv")
      data = CSV.generate do |csv|
        csv << header
        result.sort_by{|c| c[1].name}.each do |uri, character|
          csv << character.output if character.output
        end
      end
      file.put(body: data)
      Logger.t(INFO_TEAM_WRITTEN, team.id)
    end

    def self.update_db(result, team_id)
      # Sequel does not support saving multiple objects
      # in one single query, therefore the update query
      # is created manually to massively improve the speed

      overall_query = {per_spec: [], last_refresh: []}
      changes_query = {status: [], legendaries: [], weekly_snapshot: [], old_snapshots: [], tier_data: []}

      # Update specialisation data and store entire output in case the next cycle fails for a character
      result.each do |character|
        output = (JSON.generate character.output rescue "")
        overall_query[:last_refresh] << "WHEN id = #{character.id} THEN '#{self.escape(output)}' "
        overall_query[:per_spec] << "WHEN id = #{character.id} THEN '#{character.per_spec}' "
      end

      result.select{ |c| c.changed }.each do |character|
        changes_query[:status] << "WHEN id = #{character.id} THEN '#{character.status}' "
        changes_query[:legendaries] << "WHEN id = #{character.id} THEN '#{self.escape(character.legendaries)}' "
        changes_query[:weekly_snapshot] << "WHEN id = #{character.id} THEN '#{character.weekly_snapshot}' "
        changes_query[:old_snapshots] << "WHEN id = #{character.id} THEN '#{character.old_snapshots}' "
        changes_query[:tier_data] << "WHEN id = #{character.id} THEN '#{character.tier_data}' "
      end

      [overall_query, changes_query[:status].any? ? changes_query : nil]
    end

    def self.update_db_raiderio(characters)
      if characters.any? && characters.map{ |character| character.changed ? 1 : 0 }.inject(:+) > 0
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
    end

    def self.update_db_wcl(output, characters)
      if characters.any? && characters.map{ |character| character.changed ? 1 : 0 }.inject(:+) > 0
        query = "UPDATE characters SET warcraftlogs = CASE "
        characters.each do |character|
          query << "WHEN id = #{character.id} THEN '#{JSON.generate output[character.id]}' " if character.changed
        end
        query << " ELSE warcraftlogs END"

        self.query(query)
        Logger.g(INFO_TEAM_UPDATED +
          "Updated Warcraft Logs data for #{characters.length} characters")
      end
    end

    def self.bnet_query(query)
      query_string = "UPDATE characters SET per_spec = CASE "

      query.each do |team|
        team[0][:per_spec].each do |snippet|
          query_string << snippet
        end
      end

      query_string << " ELSE per_spec END, last_refresh = CASE "
      query.each do |team|
        team[0][:last_refresh].each do |snippet|
          query_string << snippet
        end
      end

      previous_col = "last_refresh"
      if query.map{ |t| t[1] }.any?
        [:status, :legendaries, :weekly_snapshot, :old_snapshots, :tier_data].each do |col|
          query_string << " ELSE #{previous_col} END, #{col.to_s} = CASE "
          previous_col = col.to_s

          query.each do |team|
            if team[1]
              team[1][col].each do |snippet|
                query_string << snippet
              end
            end
          end
        end
      end
      query_string << " ELSE #{previous_col} END"

      self.query(query_string)
      Logger.g(INFO_TEAM_UPDATED)
    end

    def self.query(query, async = true)
      # Await completion of the previous async query
      DB2.async_result

      DB2.query(query, :async => async)
    end

    def self.escape(string)
      string.gsub(/'/) {|s| "\\'"} rescue ""
    end
  end
end
