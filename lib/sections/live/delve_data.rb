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

          @character.delve_info[:total] = delve_info.find { |stat| stat[:id] == 40734 }[:quantity] rescue 0
          (1..11).each do |tier|
            @character.delve_info["tier_#{tier}".to_sym] = delve_info.find { |stat| stat[:id] == 40765 + tier }[:quantity] rescue 0
          end

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
          # Not yet implemented
        end
      end
    end
  end
end
