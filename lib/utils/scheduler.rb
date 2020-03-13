module Audit
  class Scheduler
    TIMEOUTS = {
      essentials: 5,
      collections: 10,
      raiderio: 60,
      wcl: 15,
      keystones: 5,
    }

    def initialize
      stats = {}
      loop do
        schedule = Schedule.all

        schedule.each do |worker|
          worker.schedule ||= Scheduler.schedule_work(worker).to_json
          if worker.save_changes
            worker.update(updated_at: DateTime.now)
          elsif (DateTime.now - worker.updated_at.to_datetime).to_f * 24 * 60 > TIMEOUTS[worker.type.to_sym]
            worker.destroy
            system("kubectl delete pods #{worker.name}")
            Logger.g(INFO_SCHEDULER_DESTROYED_WORKER + "Worker: #{worker.type} #{worker.name}")
          end
        end

        Logger.g(INFO_SCHEDULER_CYCLE_DONE)
        sleep SCHEDULER_PAUSE_AFTER_CYCLE
      end
    end

    def self.schedule_work(worker)
      if worker.type == "keystones"
        table = "realms"
        teams = Writer.query("SELECT id, last_refreshed_#{worker.type} FROM realms " +
                             "ORDER BY last_refreshed_#{worker.type} ASC LIMIT 10", false).to_a
      else
        table = "teams"
        teams = Writer.query("SELECT t.id, ((#{Audit.now.to_i} - IFNULL(t.last_refreshed_#{worker.type}, 0)) " +
                            "* t.refresh_factor) + t.refresh_factor AS priority, " +
                            "t.last_refreshed_#{worker.type} AS last_refreshed FROM `teams` t " +
                            "INNER JOIN guilds g ON g.id = t.guild_id WHERE g.active = 1 " +
                            "ORDER BY priority DESC LIMIT 5", false).to_a
      end
      team_ids = teams.map{ |team| team["id"] }

      # Manual query since Sequel does not support
      # single update queries for multiple objects
      Writer.query("UPDATE #{table} SET last_refreshed_#{worker.type} = #{Audit.now.to_i} WHERE id IN (#{team_ids.join(',')})", false)
      Logger.g(INFO_SCHEDULER_ADDED + "Worker: #{worker.type} #{worker.name} | Entities: #{team_ids.join(', ')}")
      team_ids
    end
  end
end
