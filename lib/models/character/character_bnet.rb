module Audit
  class CharacterBnet < Character
    def init
      # Main variables
      self.output = []
      self.data = last_refresh
      self.changed = false

      # Populate identifying data regardless of response
      self.data['name'] = name
      self.data['realm'] = REALMS[realm_id]&.name
      self.data['realm_slug'] = realm_slug
      self.data['rank'] = rank.capitalize

      # Variables for gear data
      self.gems = []
      self.ilvl = 0.0
    end

    def last_refresh
      details['last_refresh'] || {}
    end

    def process_result(response, depth = 0)
      init
      if check_api_limit_reached(response)
        depth < 3 ? (raise ApiLimitReachedException) : (return return_error(response, depth))
      end

      if check_character_api_status(response) && !self.marked_for_deletion_at && check_data_completeness(response)
        self.changed = true if self.status != "tracking"
        self.status = "tracking"

        Data.process(self, response)
        update_snapshots
        to_output
      else
        return_error(response, depth)
      end
    end

    def return_error(response, depth)
      timeouts = response[:status_codes].values.select { |status| status[:timeout] }.size
      if timeouts > 0 && depth < 3
        Logger.c(INFO_CHARACTER_TIMEOUTS_ENCOUNTERED.gsub("%N%", timeouts.to_s), id)
        raise TimeoutsEncounteredException
      end

      code = response[:status_codes].values.map { |status| status[:code] }.max
      Logger.c(ERROR_CHARACTER + "Response code: #{code}", id)
      set_status(code)
      to_output
    end

    def to_output
      HEADER.each do |value|
        self.output << (self.data[value] || 0)
      end
    end

    def set_status(code)
      new_status = if self.marked_for_deletion_at
        $errors[:tracking] += 1
        "data unavailable"
      elsif code == 404
        $errors[:tracking] += 1
        "does not exist"
      elsif code.to_s[0] == "5"
        "temporarily unavailable"
      else
        $errors[:tracking] += 1
        "not tracking"
      end
      self.changed = new_status != self.status
      self.status = new_status
    end

    def check_api_limit_reached(response)
      response[:status_codes].values.any? { |status| status[:code] == 429 }
    end

    def check_character_api_status(response)
      unless self.class == Audit::CharacterEssentials
        if gdpr_deletion?(response) && !self.marked_for_deletion_at
          update(marked_for_deletion_at: DateTime.now)
          return false
        elsif !gdpr_deletion?(response) && self.marked_for_deletion_at
          self.marked_for_deletion_at = nil
          self.save
          return true
        end
      end

      response[:status_codes][:itself][:code] == 200 && response.class == RBattlenet::HashResult
    end

    def gdpr_deletion?(response)
      return false if !response[:status]
      return true if response[:status_codes][:status][:code] == 404
      return true unless response[:status][:is_valid]

      if self.key.to_s != response[:status][:id].to_s
        self.key = response[:status][:id].to_s
      end

      false
    end

    def last_refresh_data
      [HEADER, output].transpose.to_h rescue false
    end
  end
end
