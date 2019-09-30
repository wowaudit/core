module Audit
  @@time_since_reset = nil

  class << self
    def refresh(teams, type)
      query = []
      teams.each do |team|
        begin
          Logger.t(INFO_TEAM_STARTING, team.to_i)
          Team.refresh(team.to_i, type)
        rescue ApiLimitReachedException
          Logger.t(ERROR_API_LIMIT_REACHED, team.to_i)
          sleep 60
          redo
        rescue Net::ReadTimeout, Mysql2::Error => e
          Rollbar.error(e, team_id: team.to_i, type: type)
          Logger.t(ERROR_DATABASE_CONNECTION, team.to_i)
          sleep 300
          redo
        rescue => e
          Rollbar.error(e, team_id: team.to_i, type: type)
          sleep(300) if e.class == Mysql2::Error
          Logger.t(ERROR_TEAM + "#{$!.message}\n#{$!.backtrace.join("\n")}", team.to_i)
        end
      end
    end

    def refresh_from_schedule(instance)
      loop do
        worker = Schedule.where(:name => instance).first
        if worker.schedule
          schedule = JSON.parse worker.schedule
          Logger.g(INFO_STARTING_SCHEDULE + "Teams: #{schedule.join(', ')}")

          # Ask for a new schedule
          worker.schedule = nil
          worker.save_changes

        else
          # Schedule own work if no schedule is available
          Logger.g(INFO_NO_SCHEDULE)
          schedule = Scheduler.schedule_work(instance)
        end

        self.refresh(schedule, instance.split('-').first)
        Logger.g(INFO_FINISHED_SCHEDULE)
      end
    end

    def refresh_without_schedule(instance, teams = nil)
      loop do
        schedule = teams || Scheduler.schedule_work(instance)
        Logger.g(INFO_STARTING_SCHEDULE + "Teams: #{schedule.join(', ')}")

        self.refresh(schedule, instance.split('-').first)
        Logger.g(INFO_FINISHED_SCHEDULE)
      end
    end

    def timestamp
      @@time_since_reset
    end

    def region
      @@region
    end

    def daily_date
      @daily_date ||= begin
        if DateTime.now.hour < DAILY_RESET[region]
          Date.today - 1
        else
          Date.today
        end
      end
    end

    def first_date_of_current_week
      @@first_day
    end

    def week
      @@week_number
    end

    def previous_week
      @@previous_week_number
    end

    def year
      @@year_number
    end

    def previous_week_year
      @@previous_year_number
    end

    def timestamp=(region)
      # Get the timestamp of the last weekly reset for a region, and set the current week number
      reset_time = DateTime.parse(WEEKLY_RESET[region]['day']) + (HOUR * WEEKLY_RESET[region]['hour'])
      reset_time -= (DateTime.now > reset_time ? 0 : 7)
      @@first_day = reset_time.to_date
      @@time_since_reset = reset_time.to_time.to_i
      @@week_number = reset_time.cweek.to_s
      @@year_number = reset_time.year.to_s
      @@region = region
      @@previous_week_number = (reset_time.cweek - 1).to_s
      if @@previous_week_number.to_i < 1
        @@previous_year_number = (reset_time.year - 1).to_s
        @@previous_week_number = Date.new(reset_time.year - 1, 12, 28).cweek
      else
        @@previous_year_number = @@year_number
      end
    end

    def now
      tz = TZInfo::Timezone.get(TIME_ZONE)
      Time.now.getlocal(tz.current_period.offset.utc_total_offset)
    end
  end
end
