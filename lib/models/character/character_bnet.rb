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
        data = JSON.parse response.body
        data.any? ? process(data) : return_error(response)
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

    def process(response)
      BasicData.add(self, response)
      GearData.add(self, response)
      ArtifactData.add(self, response)
      ReputationData.add(self, response)
      PvPData.add(self, response)
      InstanceData.add(self, response)
      WorldQuestData.add(self, response)
      CollectionData.add(self, response)
      HistoricalData.add(self, response)
    end

    def update_snapshots
      if !details['snapshots'][Audit.year].include? Audit.week
        details['snapshots'][Audit.year][Audit.week] = {
          'dungeons' => self.data['dungeons_done_total'],
          'wqs' => self.data['wqs_done_total'],
          'ap' => self.data['ap_obtained_total'],
          'dailies' => {}
        }
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
        dailies: details["dailies"],
        last_refresh: ([HEADER, output].transpose.to_h rescue false)
      }
    end

    def dailies_this_week(type)
      amount = details['dailies'][type].select{ |d| d >= Audit.first_date_of_current_week }.size
      if details['snapshots'][Audit.year][Audit.week]
        details['snapshots'][Audit.year][Audit.week]['dailies'][type] = amount
      end
      amount
    end

    def dailies_percentage(type)
      all_days = (tracking_since..Date.today).to_a
      missed_days = all_days - details['dailies'][type]
      return 100 if all_days.size.zero?
      (all_days.size - missed_days.size).to_f / all_days.size.to_f * 100.0
    end
  end
end
