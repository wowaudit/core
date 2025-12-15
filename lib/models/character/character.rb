module Audit
  class Character < Sequel::Model
    many_to_one :realm

    attr_accessor :output, :data, :gems, :ilvl, :changed, :details, :realm_slug, :team_rank, :delve_info, :stat_info

    dataset_module do
      def main
        filter(guest: false)
      end
    end

    set_dataset(self.main)

    def active
      super && key
    end

    def redis_id
      "#{REALMS[realm_id].redis_prefix}:#{key}_#{realm_id}" if key
    end

    def last_modified(team)
      # Don't skip a character if the last refresh was made with an older version,
      # when the new week has started, or when the character's last refresh failed
      return 0 if details['current_version'] < CURRENT_VERSION[REALMS[realm_id].kind.to_sym]
      return 0 if details['current_period'] < Audit.period
      return 0 if status != "tracking"
      return 0 unless REGISTER # Don't skip in development
      return 0 if PREVENT_SKIP_TIMESTAMP.to_i > team.last_refreshed_collections

      (data || {})['blizzard_last_modified'] || self.last_refresh['blizzard_last_modified']
    end

    def metadata
      {
        _key: id.to_s,
        team_id: team_id,
        character_id: id,
        timestamp: (last_refresh_data || {})['blizzard_last_modified'],
        max_ilvl: details['max_ilvl'],
        current_period: details['current_period'],
        current_version: details['current_version'],
        last_refresh: last_refresh_data,
        current_gear: details['current_gear'],
      }.merge(REALMS[realm_id].kind == 'live' ? {
        best_gear: details['best_gear'],
        spark_gear_s3: details['spark_gear_s3'],
        keystones: details['keystones'],
        snapshots: details["snapshots"],
        warcraftlogs: details["warcraftlogs"],
        recent_reports: details["recent_reports"],
        raiderio: details["raiderio"],
        tier_items_s3: details["tier_items_s3"],
        timeline: details["timeline"],
      } : {})
    end
  end
end
