module Audit
  class Character < Sequel::Model
    def realm
      @realm ||= Realm.find_by(id: realm_id)
    end

    def redis_id
      "#{realm.redis_prefix}:#{profile_id}"
    end

    def set_details_from_api(data)
      self.name = data.name
      self.realm_id = data.realm.id
      self.level = data.level
      self.class_id = (data.playable_class || data.character_class).id
      self.race_id = (data.playable_race || data.race).id
      self.marked_for_deletion_at = nil

      # The faction and active spec are not available in the guild members API
      self.faction_id = FACTIONS.invert[data.faction.name] if data.faction.present?
      self.current_spec_id = data.active_spec.id if data.active_spec.present?
    end
  end
end
