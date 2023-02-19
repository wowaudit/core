module Audit
  class CharacterCollections < CharacterBnet
    def essentials_only?
      false
    end

    def update_snapshots(skipped)
      current_week = details['snapshots'][Audit.year][Audit.week] || {}

      details['snapshots'][Audit.year][Audit.week] = current_week.merge({ 'vault' => 9.times.map do |i|
        [(i + 1).to_s, self.last_refresh["great_vault_slot_#{i + 1}"] || self.data["great_vault_slot_#{i + 1}"]]
      end.to_h })

      details['current_version'] = CURRENT_VERSION unless skipped
    end

    def check_data_completeness(response)
      return false unless response[:equipment] && response[:equipment][:equipped_items]

      [:achievements, :reputations].each do |type|
        return false unless response[type]&.is_a? Array
      end

      true
    end
  end
end
