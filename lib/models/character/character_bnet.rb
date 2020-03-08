module Audit
  class CharacterBnet < Character
    def init
      # Main variables
      self.output = []
      self.data = last_refresh
      self.changed = false

      # Variables for gear data
      self.gems = []
      self.ilvl = 0.0
    end

    def last_refresh
      details['last_refresh'] || {}
    end

    def process_result(response)
      init
      byebug if name == "Sema"
      if response.status_code == 200
        self.changed = true if self.status != "tracking"
        self.status = "tracking"

        if response.class == RBattlenet::EmptyResult
          return_error(response)
        else
          Data.process(self, response)

          # Migration prep
          if !self.class_id || !self.key
            self.class_id = response['class']
            self.key = response['thumbnail'].split("-avatar").first&.split("/")&.last
            self.changed = true
          end

          update_snapshots
          to_output
        end
      elsif response.status_code == 429
        raise ApiLimitReachedException
      else
        return_error(response)
      end
    end

    def return_error(response)
      Logger.c(ERROR_CHARACTER + "Response code: #{response.status_code}", id)
      set_status(response.status_code)
      to_output
    end

    def update_snapshots
      if !details['snapshots'][Audit.year].include? Audit.week
        details['snapshots'][Audit.year][Audit.week] = {
          'dungeons' => self.data['dungeons_done_total'],
          'wqs' => self.data['wqs_done_total']
        }

        # Update the previous week with M+ data
        if (details['snapshots'][Audit.previous_week_year] || {}).include? Audit.previous_week
          details['snapshots'][Audit.previous_week_year][Audit.previous_week]['m+'] =
            self.data['weekly_highest_m+']
        end
      end
    end

    def to_output
      HEADER.each do |value|
        self.output << self.data[value]
      end
    end

    def set_status(code)
      if code == 404
        self.status = "does not exist"
        $errors[:tracking] += 1
      elsif code.to_s[0] == "5"
        self.status = "temporarily unavailable"
      else
        self.status = "not tracking"
        $errors[:tracking] += 1
      end
      self.changed = true
    end

    def update
      {
        _key: id.to_s,
        team_id: team_id,
        character_id: id,
        max_ilvl: details['max_ilvl'],
        snapshots: details["snapshots"],
        last_refresh: ([HEADER, output].transpose.to_h rescue false)
      }
    end
  end
end
