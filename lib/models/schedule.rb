module Audit
  class Schedule < Sequel::Model
    many_to_one :api_key

    def base_type
      if type.include? "blizzard"
        "collections"
      else
        type.gsub("dedicated-", "").gsub("historical_", "")
      end
    end
  end
end
