module Audit
  class CharacterBlizzard < Character
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

    def process_result(response, skipped, depth = 0)
      init
      if skipped
        Data.process(self, response, true, REALMS[realm_id], self)
        update_snapshots(skipped)
        to_output
      else
        if check_api_limit_reached(response)
          depth < 3 ? (raise ApiLimitReachedException) : (return return_error(response, depth))
        end

        if check_character_api_status(response) && !self.marked_for_deletion_at && check_data_completeness(response)
          self.changed = true if self.status != "tracking"
          self.status = "tracking"

          Data.process(self, response, false, REALMS[realm_id], self)
          update_snapshots(skipped)
          to_output
        else
          return_error(response, depth)
        end
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
      HEADER[REALMS[realm_id].kind.to_sym].each do |value|
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
      if gdpr_deletion?(response) && !self.marked_for_deletion_at
        update(marked_for_deletion_at: DateTime.now)
        return false
      elsif !gdpr_deletion?(response) && self.marked_for_deletion_at
        self.marked_for_deletion_at = nil
        self.save
        return true
      end

      response[:status_codes][:itself][:code] == 200 && response.class == RBattlenet::HashResult
    end

    def gdpr_deletion?(response)
      return false if !response[:status]
      return true if response[:status_codes][:status][:code] == 404
      return true unless response[:status][:is_valid]

      if self.key.to_s != response[:status][:id].to_s
        self.key = response[:status][:id].to_s
        self.changed = true
      end

      false
    end

    def last_refresh_data
      [HEADER[REALMS[realm_id].kind.to_sym], output].transpose.to_h rescue false
    end

    def update_snapshots(skipped)
      if REALMS[realm_id].kind == 'live'
        current_week = details['snapshots'][Audit.period] || {}

        details['snapshots'][Audit.period] = current_week.merge({ 'vault' => 9.times.map do |i|
          [(i + 1).to_s, self.last_refresh["great_vault_slot_#{i + 1}"] || self.data["great_vault_slot_#{i + 1}"]]
        end.to_h })

        details['snapshots'][Audit.period]['wqs'] ||= self.data['wqs_done_total'] unless skipped
        details['snapshots'][Audit.period]['heroic_dungeons'] ||= self.data['season_heroic_dungeons'] unless skipped
      end

      details['current_version'] = CURRENT_VERSION[REALMS[realm_id].kind.to_sym] unless skipped
      details['current_period'] = Audit.period unless skipped
    end

    def check_data_completeness(response)
      return false unless response[:equipment] && response[:equipment][:equipped_items]

      if REALMS[realm_id].kind != 'classic_era'
        return false unless response[:achievements]&.is_a? Array
      end

      true
    end
  end
end
