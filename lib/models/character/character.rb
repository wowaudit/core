module Audit
  class Character < Sequel::Model
    attr_accessor :output, :data, :tier_pieces, :gems, :ilvl, :spec_id,
                  :legendaries_equipped, :ap_snapshot, :wq_snapshot,
                  :dungeon_snapshot, :specs, :changed, :details

    def realm_slug
      Realm.to_slug realm
    end

    def owned_legendaries
      @owned_legendaries ||= details['legendaries'].map{ |l| l['id'].to_i }
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
          'weekly_highest' => 0
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
    end
  end
end
