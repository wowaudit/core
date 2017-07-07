module Audit
  class Character < Sequel::Model
    attr_accessor :output, :processed_data

    def init
      self.output = []
      self.processed_data = {}
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
