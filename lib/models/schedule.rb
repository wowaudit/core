module Audit
  class Schedule < Sequel::Model
    def base_type
      type.gsub("dedicated-", "")
    end
  end
end
