module Audit
  class Scheduler
    TIMEOUTS = {
      collections: 5,
      raiderio: 60,
      wcl: 15,
      keystones: 5,
    }

    def initialize
      loop do
        schedule = Schedule.all

        schedule.each do |worker|
          worker.schedule ||= Scheduler.schedule_work(worker).to_json
          if worker.save_changes
            worker.update(updated_at: DateTime.now)
          elsif (DateTime.now - worker.updated_at.to_datetime).to_f * 24 * 60 > TIMEOUTS[worker.base_type.to_sym]
            worker.destroy
            system("kubectl delete pods #{worker.name} --wait=false")
            Logger.g(INFO_SCHEDULER_DESTROYED_WORKER + "Worker: #{worker.type} #{worker.name}")
          end
        end

        Logger.g(INFO_SCHEDULER_CYCLE_DONE)
        sleep SCHEDULER_PAUSE_AFTER_CYCLE
      end
    end

    def self.schedule_work(worker)
      if worker.type.include?("keystones")
        all_realm_ids = Realm.where(game_version: 'live').map{ |realm| realm.id }
        DB.run(
          "INSERT INTO realm_refresh_statuses (realm_id) " \
          "SELECT id FROM unnest(ARRAY[#{all_realm_ids}]::integer[]) AS id " \
          "WHERE NOT EXISTS (" \
          "SELECT 1 FROM realm_refresh_statuses rrs WHERE rrs.realm_id = id" \
          ")"
        )

        table = "realm_refresh_statuses"
        teams = DB.fetch("SELECT realm_id as id, last_refreshed_#{worker.type} FROM #{table} " +
                             "ORDER BY last_refreshed_#{worker.type} ASC NULLS FIRST LIMIT 10").to_a
      else
        table = 'teams'
        teams = DB.fetch(
          "SELECT t.id, ((#{Audit.now.to_i} - COALESCE(t.last_refreshed_#{worker.base_type}, 0)) " \
          "* t.refresh_factor) + t.refresh_factor AS priority, " \
          "t.last_refreshed_#{worker.base_type} AS last_refreshed FROM #{table} t " \
          "INNER JOIN guilds g ON g.id = t.owner_id " \
          "WHERE g.active = TRUE ORDER BY priority DESC LIMIT 5"
        ).to_a
      end
      team_ids = teams.map{ |team| team[:id] }

      # Manual query since Sequel does not support
      # single update queries for multiple objects
      DB.run("UPDATE #{table} SET last_refreshed_#{worker.base_type} = #{Audit.now.to_i} WHERE id IN (#{team_ids.join(',')})")
      Logger.g(INFO_SCHEDULER_ADDED + "Worker: #{worker.base_type} #{worker.name} | Entities: #{team_ids.join(', ')}")
      team_ids
    end
  end
end
