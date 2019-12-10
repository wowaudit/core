module Audit
  class CharacterBnet < Character
    def init
      # Main variables
      self.output = []
      self.data = {}
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
      if response.code == 200
        self.changed = true if self.status != "tracking"
        self.status = "tracking"
        data = JSON.parse(response.body) rescue (return return_error OpenStruct.new(code: 500))
        data.any? ? Data.process(self, data) : return_error(response)

        # Migration prep
        if !self.class_id || !self.key
          self.class_id = data['class']
          self.key = data['thumbnail']
          self.changed = true
        end

        update_snapshots
        to_output
      elsif response.code == 403
        raise ApiLimitReachedException
      else
        return_error(response)
      end
    end

    def return_error(response)
      Logger.c(ERROR_CHARACTER + "Response code: #{response.code}", id)
      set_status(response.code)
      to_output(details['last_refresh']) if details['last_refresh']
    end

    def update_snapshots
      if !details['snapshots'][Audit.year].include? Audit.week
        details['snapshots'][Audit.year][Audit.week] = {
          'dungeons' => self.data['dungeons_done_total'],
          'wqs' => self.data['wqs_done_total']
        }

        # Update the previous week with M+ data
        if details['snapshots'][Audit.previous_week_year].include? Audit.previous_week
          details['snapshots'][Audit.previous_week_year][Audit.previous_week]['m+'] =
            self.data['weekly_highest_m+']
        end
      end
    end

    def to_output(data = self.data)
      if self.output
        HEADER.each do |value|
          self.output << data[value]
        end
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
