module Audit
  class Guild < Sequel::Model
    one_to_many :api_keys
    one_to_many :teams

    def realm
      @realm ||= Realm.find_by(id: realm_id)
    end

    def path
      "#{realm.region.downcase}/#{realm.slug}/#{slugged_name}"
    end

    def slugged_name
      name.gsub(" ","-").downcase
    end

    def api_key
      api_keys.first
    end

    def days_remaining
      # TODO: Migrate to API?
      60
    end
  end
end
