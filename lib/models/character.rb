module Audit
  class Character < Sequel::Model
    attr_accessor :output, :processed_data, :tier_data, :gems, :ilvl, :legendaries_equipped

    def init
      #Main variables
      self.output = []
      self.processed_data = {}

      #Variables for gear data
      self.tier_data = {"head" => 0, "shoulder" =>, "back" => 0,
                        "chest" => 0, "hands" => 0, "legs" => 0}
      self.gems = []
      self.ilvl = 0.0
      self.legendaries_equipped = []
    end

    def process_result(response)
      init
      if response.code == 200
        process(JSON.parse response.body)
        to_output
      end
    end

    def process(response)
      BasicData.add(self, response)
      GearData.add(self, response)
    end

    def to_output
      HEADER.each do |value|
        self.output << self.processed_data[value]
      end
    end

    def realm_slug
      Realm.to_slug realm
    end
  end
end
