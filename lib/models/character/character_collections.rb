module Audit
  class CharacterCollections < CharacterBnet
    def essentials_only?
      false
    end

    def update_snapshots
      current_week = details['snapshots'][Audit.year][Audit.week]

      if !current_week || !current_week['wqs']&.nonzero?
        details['snapshots'][Audit.year][Audit.week] = {
          'dungeons' => self.data['dungeons_done_total'],
          'wqs' => self.data['wqs_done_total']
        }

        # Update the previous week with M+ and Vault data
        if (details['snapshots'][Audit.previous_week_year] || {}).include? Audit.previous_week
          details['snapshots'][Audit.previous_week_year][Audit.previous_week]['m+'] ||=
            self.data['weekly_highest_m+']

          details['snapshots'][Audit.previous_week_year][Audit.previous_week]['vault'] ||=
            9.times.map { |i| [(i + 1).to_s, self.data["great_vault_slot_#{i + 1}"]] }.to_h
        end
      end
    end

    def check_data_completeness(response)
      [:achievements, :pets, :mounts, :reputations, :equipment].each do |type|
        raise ApiLimitReachedException if response.dig(type, :status_code) == 429
        return false unless response[type] && response[type][type == :equipment ? 'equipped_items' : type.to_s]
      end

      true
    end
  end
end
