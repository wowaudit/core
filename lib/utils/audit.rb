module Audit
  @@time_since_reset = nil

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

  def self.timestamp
    @@time_since_reset
  end

  def self.timestamp=(region)
    # Get the timestamp of the last weekly reset for a region
    reset_day = Date.parse(WEEKLY_RESET[region]['day'])
    delta = (reset_day == Date.today ? 0 : 7)
    reset_day -= delta
    time = reset_day.to_datetime + (HOUR * WEEKLY_RESET[region]['hour'])
    @@time_since_reset = time.to_time.to_i
  end
end
