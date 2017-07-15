module Audit
  class Character < Sequel::Model
    attr_accessor :output, :data, :tier_data, :gems, :ilvl, :spec_id,
                  :legendaries_equipped, :ap_snapshot, :wq_snapshot,
                  :dungeon_snapshot, :old_snapshots, :specs,
                  :max_ilvl, :last_reset, :warcraftlogs,
                  :raiderio

    def init
      # Main variables
      self.output = []
      self.data = {}
      self.last_reset = "" #TODO

      # Variables for gear data
      self.gems = []
      self.ilvl = 0.0
      self.legendaries_equipped = []
      self.spec_id = 1

      load_persistent_data
      load_snapshots
      load_warcraftlogs_data
      load_raiderio_data
    end

    def load_snapshots
      #TODO
      self.ap_snapshot = ''
      self.wq_snapshot = ''
      self.dungeon_snapshot = ''
      self.old_snapshots = ''
    end

    def load_persistent_data
      #TODO
      self.specs = {}
      self.max_ilvl = 0
      self.tier_data = {"head" => 0, "shoulder" =>, "back" => 0,
                        "chest" => 0, "hands" => 0, "legs" => 0}
    end

    def load_warcraftlogs_data
      #TODO
      self.warcraftlogs = false
    end

    def load_raiderio_data
      #TODO
      self.raiderio = false
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
      #TODO
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
