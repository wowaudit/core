module Audit
  class Character < Sequel::Model
    attr_accessor :output, :data, :tier_pieces, :gems, :ilvl, :spec_id,
                  :legendaries_equipped, :ap_snapshot, :wq_snapshot,
                  :dungeon_snapshot, :specs, :max_ilvl, :changed,
                  :historical_snapshots

    def realm_slug
      Realm.to_slug realm
    end
  end
end
