module Audit
  module Writer

    def self.write(team, result, header)
      file = STORAGE.bucket(BUCKET).object("#{team.key}.csv")
      data = CSV.generate do |csv|
        csv << header
        result.sort_by{|c| c.name}.each do |character|
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
        result.select{ |c| c.changed }.each do |character|
          character.save
        end
      end

      Redis.update(result.reject(&:marked_for_deletion_at)) if result.any?
    end

    def self.query(query, async = true)
      # Await completion of the previous async query
      DB2.async_result
      DB2.query(query, :async => async)
    end
  end
end
