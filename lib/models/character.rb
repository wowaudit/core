module Audit
  class Character < Sequel::Model

    def process_result(response)
      if response.code == 200
        puts response.body
      end
    end

    def realm_slug
      Realm.to_slug realm
    end

    def set_uri(uri)
      self.instance_variable_set("@uri", uri)
    end
  end
end
