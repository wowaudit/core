module Audit
  class Scheduler

    #TODO: Logging
    def initialize
      loop do
        schedule = Schedule.all

        #TODO: Don't schedule the same team for multiple workers
        schedule.each do |worker|
          worker.schedule ||= self.schedule_work(worker).to_json
          worker.save_changes
          end
        end
        sleep 1
      end
    end

    def self.schedule_work(worker)
      type = worker.name.split('-').first

      if type == "regular"
        Team.reverse(:last_refreshed).limit(5)
      elsif type == "platinum"
        Team.join(:guilds, :id => :guild_id).where(:patreon => 10).reverse(:last_refreshed).limit(5)
      else
        Team.join(:guilds, :id => :guild_id).where(:patreon => 1..10).reverse(:last_refreshed).limit(5)
      end.map{ |team| team.id }
    end
  end
end
