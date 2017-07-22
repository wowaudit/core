module Audit
  @@time_since_reset = nil

  def self.refresh(teams)
    teams.each do |team|
      begin
        Logger.t(INFO_TEAM_STARTING, team.to_i)
        Team.where(id: team.to_i).first.refresh
      rescue ApiLimitReachedException
        Logger.t(ERROR_API_LIMIT_REACHED, team.to_i)
        sleep(60)
        redo
      end
    end
  end

  def self.refresh_from_schedule(instance)
    loop do
      worker = Schedule.where(:name => instance).first
      if worker.schedule
        schedule = JSON.parse worker.schedule
        Logger.g(INFO_STARTING_SCHEDULE << "Teams: #{schedule.join(', ')}")

        # Ask for a new schedule
        worker.schedule = nil
        worker.save_changes

      else
        # Schedule own work if no schedule is available
        schedule = Scheduler.schedule_work(instance)
        Logger.g(INFO_NO_SCHEDULE << "Teams: #{schedule.join(', ')}")
      end

      self.refresh(schedule)
      Logger.g(INFO_FINISHED_SCHEDULE)
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

  def self.now
    tz = TZInfo::Timezone.get(TIME_ZONE)
    Time.now.getlocal(tz.current_period.offset.utc_total_offset)
  end
end
