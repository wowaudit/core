module Audit
  class Character < Sequel::Model
    attr_accessor :uri, :result

    def process_result(response)
      sleep(0.1)
      @result = response
    end

    def realm_slug
      Realm.new.to_slug(realm)
    end
  end
end
