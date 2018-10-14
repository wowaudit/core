module Audit
  class Scheduler

    def initialize
      stats = {}
      loop do
        schedule = Schedule.all

        schedule.each do |worker|
          worker.schedule ||= Scheduler.schedule_work(worker.name).to_json
          if worker.save_changes
            stats[worker.name] = 0 unless stats[worker.name]
            stats[worker.name] += 5
            if stats[worker.name] >= 250
              Rollbar.info("250 teams refreshed by worker.", worker_name: worker.name)
              stats[worker.name] = 0
            end
          end
        end
        Logger.g(INFO_SCHEDULER_CYCLE_DONE)
        sleep SCHEDULER_PAUSE_AFTER_CYCLE
      end
    end

    def self.schedule_work(worker)
      type, patreon, instance = worker.split('-')
      type = (type == "bnet" ? "" : "_#{type}")

      if patreon == "regular"
        teams = Writer.query("SELECT t.id, t.last_refreshed#{type}, g.active FROM teams t
                              INNER JOIN guilds g ON g.id = t.guild_id WHERE g.active = 1
                              ORDER BY t.last_refreshed#{type} ASC LIMIT 5", false).to_a
      elsif patreon == "platinum"
        teams = Writer.query("SELECT t.id, t.last_refreshed#{type}, g.patreon FROM teams t
                              INNER JOIN guilds g ON g.id = t.guild_id WHERE g.patreon >= 10
                              ORDER BY t.last_refreshed#{type} ASC LIMIT 5", false).to_a
      else
        teams = Writer.query("SELECT t.id, t.last_refreshed#{type}, g.patreon FROM teams t
                              INNER JOIN guilds g ON g.id = t.guild_id WHERE g.patreon >= 1
                              ORDER BY t.last_refreshed#{type} ASC LIMIT 5", false).to_a
      end
      team_ids = teams.map{ |team| team["id"] }

      # Manual query since Sequel does not support
      # single update queries for multiple objects
      Writer.query("UPDATE teams SET last_refreshed#{type} = #{Audit.now.to_i} WHERE id IN (#{team_ids.join(',')})", false)
      Logger.g(INFO_SCHEDULER_ADDED + "Worker: #{worker} | Teams: #{team_ids.join(', ')}")

      # Log the average time since last refresh in a pretty way. TODO: Refactor since it's quite ugly code
      time = teams.map{ |team| Audit.now.to_i - team["last_refreshed#{type}"] }.inject{ |sum, el| sum + el }.to_f / 5 rescue 0
      time_log = Time.at(time).utc.strftime("%e days, %H hours, %M minutes and %S seconds")
      time_log[1] = (time_log[1].to_i - 1).to_s
      Logger.g(INFO_TIME_SINCE_LAST_REFRESH + time_log)

      team_ids
    end
  end
end
