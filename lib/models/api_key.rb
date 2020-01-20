module Audit
  class ApiKey < Sequel::Model
    many_to_one :guild
  end
end
