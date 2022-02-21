module Audit
  class Schedule < Sequel::Model
    many_to_one :api_key

    def base_type
      type.gsub("dedicated-", "")
    end
  end
end
