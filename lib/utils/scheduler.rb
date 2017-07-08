module Audit
  class Scheduler

    #TODO: Logging
    def initialize
      loop do
        schedule = Schedule.all
        schedule.each do |worker|
          worker.schedule ? nil : schedule_work(worker)
        end
        sleep 1
      end
    end

    def schedule_work(worker)
      #TODO: Don't schedule the same team for multiple workers
      type = worker.name.split('-').first

      worker.schedule = if type == "regular"
        Team.reverse(:last_refreshed).limit(5)
      elsif type == "platinum"
        Team.join(:guilds, :id => :guild_id).where(:patreon => 10).reverse(:last_refreshed).limit(5)
      else
        Team.join(:guilds, :id => :guild_id).where(:patreon => 1..10).reverse(:last_refreshed).limit(5)
      end.map{ |team| team.id }.to_json
      p worker
      worker.save_changes
    end
  end
end
