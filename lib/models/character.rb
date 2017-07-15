module Audit
  class Character < Sequel::Model
    attr_accessor :output, :data, :tier_pieces, :gems, :ilvl, :spec_id,
                  :legendaries_equipped, :ap_snapshot, :wq_snapshot,
                  :dungeon_snapshot, :specs, :max_ilvl

    def init
      # Main variables
      self.output = []
      self.data = {}

      # Variables for gear data
      self.gems = []
      self.ilvl = 0.0
      self.legendaries_equipped = []
      self.spec_id = 1

      load_persistent_data
      load_snapshots
    end

    def load_snapshots
      snapshot = JSON.parse weekly_snapshot rescue {}
      historical_snapshots = old_snapshots.split('|') rescue []

      self.ap_snapshot = snapshot['ap']
      self.wq_snapshot = snapshot['wqs']
      self.dungeon_snapshot = snapshot['dungeons']
      self.old_snapshots = historical_snapshots.map{ |week| JSON.parse week }
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
      self.tier_pieces = JSON.parse tier_data rescue {
        "head" => 0, "shoulder" => 0, "back" => 0,
        "chest" => 0, "hands" => 0, "legs" => 0
      }
    end

    def process_result(response)
      init
      if response.code == 200
        self.status = "tracking"
        process(JSON.parse response.body)
        update_snapshots
        to_output
      else
        set_status(response.code)
      end
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
        weekly_snapshot = {
          'dungeons' => self.dungeon_snapshot || self.data['dungeons_done_total'],
          'wqs' => self.wq_snapshot || self.data['wqs_done_total'],
          'ap' => self.ap_snapshot || self.data['ap_obtained_total']
        }
      end
    end

    def to_output
      HEADER.each do |value|
        self.output << self.data[value]
      end
    end

    def set_status(code)
      if code == 404
        self.status = "doesn't exist"
      elsif code.to_s[0] == "5"
        self.status = "temporarily unavailable"
      else
        self.status = "not tracking"
      end
    end

    def realm_slug
      Realm.to_slug realm
    end
  end
end
