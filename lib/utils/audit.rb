module Audit
  @@reset_timestamp = nil

  class << self
    def refresh(entities, type)
      query = []
      entities.each do |team|
        begin
          Logger.t(INFO_TEAM_STARTING, team.to_i)
          (type == "keystones" ? Realm : Team).refresh(team.to_i, type)
        rescue ApiLimitReachedException
          Logger.t(ERROR_API_LIMIT_REACHED, team.to_i)
          sleep 60
          redo
        rescue Net::ReadTimeout, Mysql2::Error => e
          Rollbar.error(e, team_id: team.to_i, type: type)
          Logger.t(ERROR_DATABASE_CONNECTION, team.to_i)
          sleep 180
          redo
        rescue RBattlenet::Errors::Unauthorized
          Logger.t(ERROR_NO_API_KEY, team.to_i)
        rescue => e
          Rollbar.error(e, team_id: team.to_i, type: type)
          sleep(180) if e.class == Mysql2::Error
          Logger.t(ERROR_TEAM + "#{$!.message}\n#{$!.backtrace.join("\n")}", team.to_i)
        end
      end
    end

    def refresh_from_schedule(type)
      loop do
        worker = Schedule.where(name: `hostname`.strip).first || register_worker(type)
        if worker.schedule
          schedule = JSON.parse worker.schedule
          Logger.g(INFO_STARTING_SCHEDULE + "Entities: #{schedule.join(', ')}")

          # Ask for a new schedule
          worker.schedule = nil
          worker.save_changes

        else
          # Schedule own work if no schedule is available
          Logger.g(INFO_NO_SCHEDULE)
          schedule = Scheduler.schedule_work(worker)
          worker.update(updated_at: DateTime.now)
        end

        self.refresh(schedule, worker.base_type)
        Logger.g(INFO_FINISHED_SCHEDULE)
      end
    end

    def refresh_without_schedule(type, entities = nil)
      loop do
        Logger.g(INFO_STARTING_SCHEDULE + "Entities: #{entities.join(', ')}")
        self.refresh(entities, type)

        Logger.g(INFO_FINISHED_SCHEDULE)
      end
    end

    def fetch_occurrences(type)
      zones = type == "wcl" ? 1..2 : 1..8
      schedules = Audit::Schedule.where(type: type).map(&:zone)
      zones.map{ |zone| [zone, schedules.count{ |key| key == zone }] }.to_h
    end

    def register_worker(type, zone)
      Logger.g(INFO_REGISTERED_WORKER)
      Schedule.find_or_create(
        name: `hostname`.strip,
      ) do |schedule|
        schedule.type = type
        schedule.active = true
        schedule.zone = (type.to_s == 'wcl' ? 1 : zone)
        schedule.created_at = DateTime.now
        schedule.updated_at = DateTime.now
      end
    end

    def authenticate(id, secret)
      attempts = 0

      begin
        RBattlenet.authenticate(client_id: id, client_secret: secret)
      rescue
        attempts += 1
        if attempts < 5
          retry
        else
          raise
        end
      end
    end

    def timestamp
      @@reset_timestamp
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

    def period
      641 + ((@@reset_timestamp + 302400) - 1523372400) / 604799
    end

    def period_from_timestamp(timestamp)
      period - (((@@reset_timestamp + 604799) - timestamp) / 604799)
    end

    def previous_week_year
      @@previous_year_number
    end

    def timestamp=(region)
      # Get the timestamp of the last weekly reset for a region, and set the current week number
      reset_time = DateTime.parse(WEEKLY_RESET[region]['day']) + (HOUR * WEEKLY_RESET[region]['hour'])
      reset_time -= (DateTime.now > reset_time ? 0 : 7)
      @@first_day = reset_time.to_date
      @@reset_timestamp = reset_time.to_time.to_i
      @@week_number = reset_time.cweek.to_s
      @@year_number = reset_time.year.to_s
      @@region = region
      @@previous_week_number = (reset_time.cweek - 1).to_s
      @@keystone_period = 0
      if @@previous_week_number.to_i < 1
        @@previous_year_number = ((reset_time + 7).year - 1).to_s
        @@previous_week_number = Date.new((reset_time + 7).year - 1, 12, 28).cweek.to_s
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
