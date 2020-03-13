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
      check_character_api_status(response)

      if response.status_code == 200
        self.changed = true if self.status != "tracking"
        self.status = "tracking"

        if response.class == RBattlenet::EmptyResult
          return_error(response)
        else
          Data.process(self, response)

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
      current_week = details['snapshots'][Audit.year][Audit.week]
      if !current_week || !current_week['wqs'] || !current_week['dungeons']
        details['snapshots'][Audit.year][Audit.week] = {
          'dungeons' => self.data['dungeons_done_total'],
          'wqs' => self.data['wqs_done_total']
        }

        # Update the previous week with M+ data
        if (details['snapshots'][Audit.previous_week_year] || {}).include? Audit.previous_week
          details['snapshots'][Audit.previous_week_year][Audit.previous_week]['m+'] ||=
            self.data['weekly_highest_m+']
        end
      end
    end

    def to_output
      HEADER.each do |value|
        self.output << (self.data[value] || 0)
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

    def check_character_api_status(response)
      return unless self.class == Audit::CharacterCollections

      if gdpr_deletion?(response) && !self.marked_for_deletion_at
        update(marked_for_deletion_at: DateTime.now)
      elsif !gdpr_deletion?(response) && self.marked_for_deletion_at
        update(marked_for_deletion_at: nil)
      end
    end

    def gdpr_deletion?(response)
      return false if !response.status
      return true if response.status.status_code == 404
      return true unless response.status.is_valid
      return true if key.to_s != response.status.id.to_s
      false
    end
  end
end
