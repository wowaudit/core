module Audit
  class Scheduler
    TIMEOUTS = {
      essentials: 5,
      raiderio: 60,
      wcl: 15,
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
      teams = Writer.query("SELECT t.id, ((#{Audit.now.to_i} - IFNULL(t.last_refreshed_#{worker.type}, 0)) " +
                           "* t.refresh_factor) + t.refresh_factor AS priority, " +
                           "t.last_refreshed_#{worker.type} AS last_refreshed FROM `teams` t " +
                           "INNER JOIN guilds g ON g.id = t.guild_id WHERE g.active = 1 " +
                           "ORDER BY priority DESC LIMIT 5", false).to_a
      team_ids = teams.map{ |team| team["id"] }

      # Manual query since Sequel does not support
      # single update queries for multiple objects
      Writer.query("UPDATE teams SET last_refreshed_#{worker.type} = #{Audit.now.to_i} WHERE id IN (#{team_ids.join(',')})", false)
      Logger.g(INFO_SCHEDULER_ADDED + "Worker: #{worker.type} #{worker.name} | Teams: #{team_ids.join(', ')}")

      # Log the average time since last refresh in a pretty way. TODO: Refactor since it's quite ugly code
      time = teams.map{ |team| Audit.now.to_i - team["last_refreshed"] }.inject{ |sum, el| sum + el }.to_f / 5 rescue 0
      time_log = Time.at(time).utc.strftime("%e days, %H hours, %M minutes and %S seconds")
      time_log[1] = (time_log[1].to_i - 1).to_s
      Logger.g(INFO_TIME_SINCE_LAST_REFRESH + time_log)

      team_ids
    end
  end
end
