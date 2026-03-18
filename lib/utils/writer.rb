module Audit
  module Writer

    def self.write(team, result, header)
      json = ([header] + result.map(&:output).compact.reject(&:empty?)).to_json
      file = STORAGE[team.guild.realm.game_version.to_sym].bucket(BUCKET).object("acc-#{team.readonly_key}.json")
      file.put(body: json)

      Logger.t(INFO_TEAM_WRITTEN, team.id)
    end

    def self.update_db(results)
      results.select{ |c| c.changed }.each do |result|
        result.character.save
      end

      tracking_characters = results.select { |r| r.character.status == 'tracking' }
      DB.run("UPDATE characters SET refreshed_at = NOW() WHERE id IN (#{tracking_characters.map{ |c| c.character.id }.join(',')})")
    end
  end
end
