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
      self.legendaries_equipped = []
      self.spec_id = 1
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
      self.output = details['last_refresh'] if details['last_refresh']
    end

    def process(response)
      BasicData.add(self, response)
      GearData.add(self, response)
      # Continue refactoring here
      ArtifactData.add(self, response)
      ReputationData.add(self, response)
      InstanceData.add(self, response)
      WorldQuestData.add(self, response)
      PvPData.add(self, response)
      LegendaryData.add(self, response)
      CollectionData.add(self, response)
      SpecData.add(self, response)
      HistoricalData.add(self, response)
    end

    def update_snapshots
      if !details['snapshots'][Audit.year].include? Audit.week
        details['snapshots'][Audit.year][Audit.week] = {
          dungeons: self.data['dungeons_done_total'],
          wqs: self.data['wqs_done_total'],
          ap: self.data['ap_obtained_total']
        }
      end
    end

    def to_output
      if self.output
        HEADER.each do |value|
          self.output << self.data[value]
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
  end
end
