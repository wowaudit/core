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
      # TODO: Fix HashResult to recognise these as empty when it happens (sporadically)
      # also change the structure to not have double nested data like this
      response[:achievements] && response[:achievements]['achievements'] &&
      response[:pets] && response[:pets]['pets'] &&
      response[:mounts] && response[:mounts]['mounts'] &&
      response[:reputations] && response[:reputations]['reputations'] &&
      response[:equipment] && response[:equipment]['equipped_items']
    end
  end
end
