module Wowaudit
  module Retrievers
    class HistoricalKeystones
      def self.retrieve_group(realm_id)
        realm = Audit::Realm.find(realm_id)

        RBattlenet.set_options(region: realm.region, namespace: realm.namespace, locale: "en_GB", concurrency: 25, response_type: :hash)
        Audit.timestamp = realm.region

        (Audit::Season.current.data[:first_period]..(Audit.period - 1)).to_a.each do |period|
          Wowaudit::Retrievers::Keystones.retrieve(realm, period)
        end
      end
    end
  end
end
