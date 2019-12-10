module Audit
  module Writer

    def self.write(team, result, header)
      file = STORAGE.bucket(BUCKET).object("#{team.key_code}.csv")
      data = CSV.generate do |csv|
        csv << header
        result.sort_by{|c| c[1].name}.each do |uri, character|
          csv << character.output if character.output && character.output.any?
        end
      end
      file.put(body: data)
      Logger.t(INFO_TEAM_WRITTEN, team.id)
    end

    def self.update_db(result, bnet = false)
      # Update status in SQL database for Bnet updates
      # since the status is shown on the website
      if bnet && result.select{ |c| c.changed }.any?
        query_string = "UPDATE characters SET status = CASE "
        result.select{ |c| c.changed }.each do |character|
          query_string << "WHEN id = #{character.id} THEN '#{character.status}' "
        end
        query_string << "ELSE status END"
        self.query(query_string)


        # Migration prep quick 'n dirty
        query_string = "UPDATE characters SET `key` = CASE "
        result.select{ |c| c.changed }.each do |character|
          query_string << "WHEN id = #{character.id} THEN '#{character.key}' "
        end
        query_string << "ELSE `key` END"
        byebug
        self.query(query_string)

        query_string = "UPDATE characters SET class_id = CASE "
        result.select{ |c| c.changed }.each do |character|
          query_string << "WHEN id = #{character.id} THEN '#{character.class_id}' "
        end
        query_string << "ELSE class_id END"
        self.query(query_string)
      end

      # Update data
      arango_data = []
      result.each do |character|
        arango_data << character.update
      end

      Arango.update(arango_data)
    end

    def self.query(query, async = true)
      # Await completion of the previous async query
      DB2.async_result
      DB2.query(query, :async => async)
    end
  end
end
