module Audit

  def self.refresh(teams)
    teams.each do |team|
      Team.where(id: team.to_i).first.refresh
    end
  end

  def self.refresh_from_schedule(instance)
    loop do
      worker = Schedule.where(:name => instance).first
      if worker.schedule
        schedule = JSON.parse worker.schedule

        #Ask for a new schedule
        worker.schedule = nil
        worker.save_changes

      else
        #TODO: Make sure other workers don't schedule the same work
        schedule = Scheduler.schedule_work(instance)
      end

      self.refresh(schedule)
      p "cycle done"
    end
  end
end
