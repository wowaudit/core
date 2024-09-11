module Audit
  module Live
    class DelveData < Data
      def add
        begin
          delve_category = @data[:achievement_statistics][:categories].find do |category|
            category[:name] == "Delves"
          end

          delve_meta = delve_category[:sub_categories].first[:statistics]
          delve_info = delve_category[:statistics]
          delves_this_week = []

          @character.delve_info[:total] = delve_info.find { |stat| stat[:id] == 40734 }[:quantity] rescue 0
          (1..11).each do |tier|
            @character.delve_info["tier_#{tier}".to_sym] = season_amount = delve_info.find { |stat| stat[:id] == 40765 + tier }[:quantity] rescue 0
            week_amount = season_amount - (@character.details.dig('snapshots', Audit.period.to_s, 'delve_info', "tier_#{tier}") || 0)
            delves_this_week += week_amount.to_i.times.map { tier }
          end

          delves_this_week.reverse!

          @character.data['coffer_keys'] = delve_meta.find { |stat| stat[:id] == 40749 }[:quantity] rescue 0
          @character.data['season_delves'] = @character.delve_info[:total]
          @character.data['week_delves'] =
            [@character.delve_info[:total] - @character.details['snapshots'][Audit.period.to_s]['delve_info']['total'], 0].max rescue 0
        rescue
          nil
        end

        if GREAT_VAULT_BLACKLISTED_PERIODS.include?(Audit.period)
          @character.data['great_vault_slot_7'] = ""
          @character.data['great_vault_slot_8'] = ""
          @character.data['great_vault_slot_9'] = ""
        else
          @character.data['great_vault_slot_7'] = Season.current.data[:vault_ilvl][:delve][[delves_this_week[0] || 0, 11].min] || ""
          @character.data['great_vault_slot_8'] = Season.current.data[:vault_ilvl][:delve][[delves_this_week[3] || 0, 11].min] || ""
          @character.data['great_vault_slot_9'] = Season.current.data[:vault_ilvl][:delve][[delves_this_week[7] || 0, 11].min] || ""
        end
      end
    end
  end
end
