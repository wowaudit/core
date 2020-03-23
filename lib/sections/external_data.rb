module Audit
  class ExternalData < Data
    ESSENTIAL = true

    def add
      add_warcraftlogs_data
      add_raiderio_data
    end

    def add_warcraftlogs_data
      RAID_DIFFICULTIES.each_key do |diff|
        output = []
        WCL_IDS.each do |boss|
          output << (@character.details['warcraftlogs'][diff.to_s][boss]&.to_i || '-')
        end
        @character.data["WCL_#{RAID_DIFFICULTIES[diff]}"] = output.join('|')
      end
    end

    def add_raiderio_data
      @character.data['m+_score'] =
        (@character.details['raiderio']['score'] rescue '')

      @character.data['season_highest_m+'] =
        (@character.details['raiderio']['season_highest'] rescue '-')

      @character.data['weekly_highest_m+'] =
        [
          (@character.details['raiderio']['weekly_highest'] rescue 0) || 0,
          (@character.details['raiderio']['legacy_weekly_highest'] rescue 0) || 0
        ].max
    end
  end
end
