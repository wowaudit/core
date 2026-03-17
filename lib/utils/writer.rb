module Audit
  module Writer

    def self.write(team, result, header)
      json = ([header] + result.sort_by{|c| c.name}.map(&:output).compact.reject(&:empty?)).to_json
      file = STORAGE[team.guild.realm.game_version.to_sym].bucket(BUCKET).object("acc-#{team.key}.json")
      file.put(body: json)

      Logger.t(INFO_TEAM_WRITTEN, team.id)
    end

    def self.update_db(result)
      if result.select{ |c| c.changed }.any?
        result.select{ |c| c.changed }.each do |character|
          character.save
        end
      end

      tracking_users = result.select { |r| r.character.status == 'tracking' }
      self.query("UPDATE characters SET refreshed_at = NOW() WHERE id IN (#{tracking_users.map{ |c| c.id }.join(',')})")
    end

    def self.query(query, async = true)
      # Await completion of the previous async query
      DB.async_result
      DB.query(query, :async => async)
    end
  end
end
