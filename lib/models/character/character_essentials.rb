module Audit
  class CharacterEssentials < CharacterBnet
    def essentials_only?
      true
    end

    def check_data_completeness(response)
      # TODO: Fix HashResult to recognise these as empty when it happens (sporadically)
      # also change the structure to not have double nested data like this
      response[:equipment] && response[:equipment]['equipped_items']
    end
  end
end
