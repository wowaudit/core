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

        self.refresh(schedule)
      else
        #TODO: If there is no schedule available, fetch
        #the longest not refreshed guild and refresh it
      end
      p "cycle done"
    end
  end
end
