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

      load_persistent_data
      load_snapshots
    end

    def load_snapshots
      snapshot = JSON.parse (weekly_snapshot.to_s.empty? ? "{}" : weekly_snapshot)
      historical_snapshots = old_snapshots.split('|') rescue []

      self.ap_snapshot = snapshot['ap']
      self.wq_snapshot = snapshot['wqs']
      self.dungeon_snapshot = snapshot['dungeons']
      self.historical_snapshots = historical_snapshots.map{ |week| JSON.parse week }
    end

    def load_persistent_data
      self.specs = {1 => [0,0], 2 => [0,0], 3 => [0,0], 4 => [0,0]}
      if per_spec and per_spec != 'None'
        spec_data = per_spec.split('|')
        spec_data[0...-1].map{ |spec| spec.split('_')}.each_with_index do |data, index|
          self.specs[index + 1] = data
        end
      end

      self.max_ilvl = spec_data[-1].to_i rescue 0
      self.tier_pieces = JSON.parse (tier_data.to_s.empty? ? BLANK_TIER_DATA : tier_data)
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
      self.output = ( JSON.parse last_refresh ) rescue nil
    end

    def process(response)
      BasicData.add(self, response)
      GearData.add(self, response)
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
      if !self.ap_snapshot or !self.wq_snapshot or !self.dungeon_snapshot
        new_snapshot = {
          'dungeons' => self.dungeon_snapshot || self.data['dungeons_done_total'],
          'wqs' => self.wq_snapshot || self.data['wqs_done_total'],
          'ap' => self.ap_snapshot || self.data['ap_obtained_total']
        }
        self.weekly_snapshot = JSON.generate new_snapshot
        if self.old_snapshots.is_a? String
          self.old_snapshots << "|#{self.weekly_snapshot}"
        else
          self.old_snapshots = self.weekly_snapshot
        end
        self.changed = true
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
  end
end
