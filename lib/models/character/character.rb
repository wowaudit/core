module Audit
  class Character < Sequel::Model
    attr_accessor :output, :data, :tier_pieces, :gems, :ilvl, :spec_id,
                  :legendaries_equipped, :ap_snapshot, :wq_snapshot,
                  :dungeon_snapshot, :specs, :max_ilvl, :changed,
                  :historical_snapshots, :all_legendaries, :details

    def realm_slug
      Realm.to_slug realm
    end

    def wcl_parsed
      @warcraftlogs_parsed ||= JSON.parse warcraftlogs
    end

    def raiderio_parsed
      @raiderio_parsed ||= JSON.parse raiderio
    end

    def update
      ArangoDocument.new(key: id.to_s, body: {
        team_id: team_id,
        character_id: id,
        warcraftlogs_id: details["warcraftlogs_id"],
        legendaries: details["legendaries"],
        snapshots: details["snapshots"],
        tier_data: details["tier_data"],
        spec_data: details["spec_data"],
        pantheon_trinket: details["pantheon_trinket"],
        raiderio: details["raiderio"],
        warcraftlogs: details["warcraftlogs"],
        last_refresh: ([HEADER, output].transpose.to_h rescue false
      })
    end

    def verify_details
      # Set ids if not present
      details['team_id'] = team_id if !details['team_id']
      details['character_id'] = id if !details['character_id']
      details['warcraftlogs_id'] = nil if !details['warcraftlogs_id']

      # Initialise snapshots if not present
      if !details['snapshots'].is_a? Hash
        details['snapshots'] = {}
      end

      if !details['snapshots'].include? Audit.year
        details['snapshots'][Audit.year] = {}
      end

      # Initialise tier data if not present
      if !details['tier_data'].is_a? Hash
        details['tier_data'] = {
          head: 0,
          shoulder: 0,
          back: 0,
          chest: 0,
          hands: 0,
          legs: 0
        }
      end

      # Initialise pantheon trinket data if not present
      if !details['pantheon_trinket'].is_a? Hash
        details['pantehon_trinket'] = {
          type: 'None',
          ilvl: 0
        }
      end

      # Initialise Raider.io data if not present
      if !details['raiderio'].is_a? Hash
        details['raiderio'] = {
          score: 0,
          season_highest: 0,
          weekly_highest: 0
        }
      end

      # Initialise Warcraft Logs data if not present
      if !details['warcraftlogs'].is_a? Hash
        details['warcraftlogs'] = {3 => {}, 4 => {}, 5 => {}}
        details['warcraftlogs'].keys.each do |metric|
          WCL_IDS.each do |id|
            details['warcraftlogs'][metric][id] = {
              best: '-',
              median: '-',
              average: '-'
            }
          end
        end
      end

      # Initialise spec data if not present
      if !details['spec_data'].is_a? Hash
        details['spec_data'] = {
          '1' => { traits: 0, ilvl: 0 },
          '2' => { traits: 0, ilvl: 0 },
          '3' => { traits: 0, ilvl: 0 },
          '4' => { traits: 0, ilvl: 0 }
        }
      end

      # Initialise legendary data if not present
      if !details['legendaries'].is_a? Array
        details['legendaries'] = []
      end

      # Disable last refresh if not present
      if !details['last_refresh'].is_a? Hash
        details['last_refresh'] = false
      end
    end
  end
end
