module Audit
  class ExternalData < Data
    ESSENTIAL = true
    SKIPPABLE = false

    def add
      add_warcraftlogs_data
      add_raiderio_data
      add_leaderboard_data
    end

    def add_warcraftlogs_data
      RAID_DIFFICULTIES.each_key do |diff|
        output = []
        WCL_IDS.each do |boss|
          value = @character.details['warcraftlogs'][diff.to_s][boss]
          output << (value ? (value == '-' ? '-' : value&.to_f.to_i) : '-')
        end
        @character.data["WCL_#{RAID_DIFFICULTIES[diff]}"] = output.join('|')
      end
    end

    def add_raiderio_data
      @character.data['season_highest_m+'] =
        (@character.details['raiderio']['season_highest'] rescue '-')

      @character.data['weekly_highest_m+'] =
        [
          (@character.details['raiderio']['weekly_highest'] rescue 0) || 0,
          (@character.details['raiderio']['top_ten_highest'][0] rescue 0) || 0
        ].max
    end

    def add_leaderboard_data
      # Use either Raider.io data or leaderboard data, whichever is more complete at the moment
      dungeon_data = if @character.details['raiderio']['top_ten_highest'].sum > @character.details['raiderio']['leaderboard_runs'].sum
        @character.details['raiderio']['top_ten_highest']
      else
        (@character.details['raiderio']['leaderboard_runs'] || []).sort_by { |h| h * -1 }
      end

      @character.data['great_vault_slot_4'] = GREAT_VAULT_TO_ILVL['dungeon'][[dungeon_data[0] || 0, 20].min] || ""
      @character.data['great_vault_slot_5'] = GREAT_VAULT_TO_ILVL['dungeon'][[dungeon_data[3] || 0, 20].min] || ""
      @character.data['great_vault_slot_6'] = GREAT_VAULT_TO_ILVL['dungeon'][[dungeon_data[7] || 0, 20].min] || ""
    end
  end
end
