module Audit
  class CharacterCollections < CharacterBnet
    def essentials_only?
      false
    end

    def update_snapshots
      current_week = details['snapshots'][Audit.year][Audit.week] || {}

      details['snapshots'][Audit.year][Audit.week] = current_week.merge({ 'vault' => 3.times.map do |i|
        [(i + 1).to_s, self.last_refresh["great_vault_slot_#{i + 1}"] || self.data["great_vault_slot_#{i + 1}"]]
      end.to_h })

      if !current_week['wqs']&.nonzero?
        details['snapshots'][Audit.year][Audit.week]['wqs'] = self.data['wqs_done_total']

        # Update the previous week with M+ and Vault data
        if (details['snapshots'][Audit.previous_week_year] || {}).include? Audit.previous_week
          details['snapshots'][Audit.previous_week_year][Audit.previous_week]['m+'] ||=  self.data['weekly_highest_m+']

          last_week_vault = details['snapshots'][Audit.previous_week_year][Audit.previous_week]['vault'] || { '1' => '-', '2' => '-', '3' => '-', '4' => '-', '5' => '-', '6' => '-' }

          details['snapshots'][Audit.previous_week_year][Audit.previous_week]['vault'] = last_week_vault.merge(3.times.map do |i|
            [(i + 7).to_s, self.last_refresh["great_vault_slot_#{i + 7}"] || self.data["great_vault_slot_#{i + 7}"]]
          end.to_h)
        end
      end
    end

    def check_data_completeness(response)
      [:achievements, :mounts, :reputations, :equipment].each do |type|
        raise ApiLimitReachedException if response.dig(type, :status_code) == 429
        return false unless response[type] && response[type][type == :equipment ? 'equipped_items' : type.to_s]
      end

      true
    end
  end
end
