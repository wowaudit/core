module Audit
  class CharacterEssentials < CharacterBnet
    def essentials_only?
      true
    end

    def update_snapshots
      nil # Don't update snapshots when only the essential data is there
    end

    def check_data_completeness(response)
      response[:equipment] && response[:equipment][:equipped_items]
    end
  end
end
