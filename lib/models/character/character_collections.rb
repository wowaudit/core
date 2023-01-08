module Audit
  class CharacterCollections < CharacterBnet
    def essentials_only?
      false
    end

    def update_snapshots
      current_week = details['snapshots'][Audit.year][Audit.week] || {}

      details['snapshots'][Audit.year][Audit.week] = current_week.merge({ 'vault' => 9.times.map do |i|
        [(i + 1).to_s, self.last_refresh["great_vault_slot_#{i + 1}"] || self.data["great_vault_slot_#{i + 1}"]]
      end.to_h })
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
