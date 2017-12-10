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
      # Update status in SQL database
      # since it's shown on the website
      if result.select{ |c| c.changed }.any?
        query_string = "UPDATE characters SET status = CASE "
        result.select{ |c| c.changed }.each do |character|
          query_string << "WHEN id = #{character.id} THEN '#{character.status}' "
        end
        query_string << "ELSE status END"
        self.query(query_string)
      end

      # Update specialisation data and store entire output in case the next cycle fails for a character
      arango_data = []
      result.each do |character|
        arango_data << character.update
      end

      Arango.update(arango_data)
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
