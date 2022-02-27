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

    def historical_snapshots
      return @historical_snapshots if @historical_snapshots
      @historical_snapshots = []
      details['snapshots'].keys.sort_by(&:to_i).each do |year|
        details['snapshots'][year].keys.sort_by(&:to_i).each do |week|
          @historical_snapshots << details['snapshots'][year][week]
        end
      end
      @historical_snapshots
    end

    def verify_details
      # Set ids and max item level if not present
      details['team_id'] = team_id if !details['team_id']
      details['character_id'] = id if !details['character_id']
      details['max_ilvl'] = 0 if !details['max_ilvl']

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

      # Disable last refresh if not present
      if !details['last_refresh'].is_a? Hash
        details['last_refresh'] = false
      end

      if !details['best_gear'].is_a? Hash
        details['best_gear'] = ITEMS.map { |item| [item, { ilvl: 0 }] }.to_h
      end

      if !details['tier_items'].is_a? Hash
        details['tier_items'] = TIER_ITEMS_BY_SLOT.keys.map { |item| [item, 0] }.to_h
      end

      if !details['great_vault'].is_a? Hash
        details['great_vault'] = {
          'dungeons' => [],

        }
      end
    end

    def metadata
      {
        _key: id.to_s,
        team_id: team_id,
        character_id: id,
        max_ilvl: details['max_ilvl'],
        snapshots: details["snapshots"],
        warcraftlogs: details["warcraftlogs"],
        raiderio: details["raiderio"],
        last_refresh: last_refresh_data,
        best_gear: details['best_gear']
      }
    end
  end
end
