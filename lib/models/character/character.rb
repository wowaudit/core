module Audit
  class Character < Sequel::Model
    many_to_one :realm

    attr_accessor :output, :data, :gems, :ilvl, :changed, :details, :realm_slug

    def tracking_since
      date = created_at || EXPANSION_START
      [EXPANSION_START, date.to_date].max
    end

    def active
      super && key
    end

    def redis_id
      "#{REALMS[realm_id].redis_prefix}:#{key}_#{realm_id}" if key
    end

    def historical_snapshots
      @historical_snapshots ||= begin
        snapshots = []
        details['snapshots'].keys.sort_by(&:to_i).each do |year|
          details['snapshots'][year].keys.sort_by(&:to_i).each do |week|
            snapshots << details['snapshots'][year][week]
          end
        end
        snapshots
      end
    end

    def verify_details
      # Set ids and max item level if not present
      details['team_id'] = team_id if !details['team_id']
      details['character_id'] = id if !details['character_id']
      details['max_ilvl'] = 0 if !details['max_ilvl']
      details['current_version'] = 0 if !details['current_version']
      details['current_period'] = 0 if !details['current_period']

      # Disable last refresh if not present
      if !details['last_refresh'].is_a? Hash
        details['last_refresh'] = false
      end

      if !details['current_gear'].is_a? Hash
        details['current_gear'] = ITEMS[REALMS[realm_id].kind.to_sym].map { |item| [item, { ilvl: 0 }] }.to_h
      end

      if REALMS[realm_id].kind == 'live'
        # Initialise snapshots if not present
        if !details['snapshots'].is_a? Hash
          details['snapshots'] = {}
        end

        if !details['snapshots'].include? Audit.year
          details['snapshots'][Audit.year] = {}
        end

        # Initialise Raider.io data if not present
        if !details['raiderio'].is_a? Hash
          details['raiderio'] = {
            'score' => 0,
            'season_highest' => 0,
            'weekly_highest' => 0,
            'period' => 0,
            'top_ten_highest' => [],
            'leaderboard_runs' => [],
          }
        end

        # Initialise Warcraft Logs data if not present
        if !details['warcraftlogs'].is_a? Hash
          details['warcraftlogs'] = { '1' => {}, '3' => {}, '4' => {}, '5' => {} }
        end

        if !details['best_gear'].is_a? Hash
          details['best_gear'] = ITEMS[:live].map { |item| [item, { ilvl: 0 }] }.to_h
        end

        if !details['spark_gear_s2'].is_a? Hash
          details['spark_gear_s2'] = ITEMS[:live].map { |item| [item, {}] }.to_h
        end

        if !details['tier_items_s2'].is_a? Hash
          details['tier_items_s2'] = TIER_ITEMS_BY_SLOT.keys.map { |item| [item, { 'ilvl' => 0, 'difficulty' => '' }] }.to_h
        end

        if !details['keystones'].is_a? Hash
          details['keystones'] = {}
        end
      end
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
        spark_gear_s2: details['spark_gear_s2'],
        keystones: details['keystones'],
        snapshots: details["snapshots"],
        warcraftlogs: details["warcraftlogs"],
        raiderio: details["raiderio"],
        tier_items_s2: details["tier_items_s2"],
      } : {})
    end
  end
end
