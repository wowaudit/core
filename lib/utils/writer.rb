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
  end
end
