module Audit
  class Scheduler

    def initialize
      loop do
        schedule = Schedule.all

        schedule.each do |worker|
          Logger.g(INFO_WORKER_BUSY << "Worker: #{worker}") if worker.schedule
          worker.schedule ||= Scheduler.schedule_work(worker).to_json
          worker.save_changes
        end
        Logger.g(INFO_SCHEDULER_CYCLE_DONE)
        sleep SCHEDULER_PAUSE_AFTER_CYCLE
      end
    end

    def self.schedule_work(worker)
      type = worker.name.split('-').first

      if type == "regular"
        teams = Team.reverse(:last_refreshed).limit(5)
      elsif type == "platinum"
        teams = Team.join(:guilds, :id => :guild_id).where(:patreon => 10).reverse(:last_refreshed).limit(5)
      else
        teams = Team.join(:guilds, :id => :guild_id).where(:patreon => 1..10).reverse(:last_refreshed).limit(5)
      end
      teams = teams.map{ |team| team.id }

      # Manual query since Sequel does not support
      # single update queries for multiple objects
      DB2.query("UPDATE teams SET last_refreshed = #{Audit.now.to_i} WHERE id IN (#{teams.join(',')})")

      Logger.g(INFO_SCHEDULER_ADDED << "Worker: #{worker} | Teams: #{teams.join(', ')}")
      teams
    end

    def self.schedule_raiderio_work
      teams = Team.reverse(:last_refreshed_raiderio).limit(5).map{ |team| team.id }
    end

    def self.schedule_wcl_work
      teams = Team.reverse(:last_refreshed_WCL).limit(5).map{ |team| team.id }
    end
  end
end
