module Audit
  class Guild < Sequel::Model
    one_to_many :api_keys
    one_to_many :teams
    many_to_one :realm

    def path
      "#{REALMS[realm_id].region.downcase}/#{slugged_realm}/#{slugged_name}"
    end

    def slugged_name
      name.gsub(" ","-").downcase
    end

    def slugged_realm
      Realm.to_slug(REALMS[realm_id])
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
