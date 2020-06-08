module Audit
  class CharacterCollections < CharacterBnet
    def essentials_only?
      false
    end

    def check_data_completeness(response)
      # TODO: Fix HashResult to recognise these as empty when it happens (sporadically)
      # also change the structure to not have double nested data like this
      response[:achievements] && response[:achievements]['achievements'] &&
      response[:titles] && response[:titles]['titles'] &&
      response[:pets] && response[:pets]['pets'] &&
      response[:mounts] && response[:mounts]['mounts'] &&
      response[:reputations] && response[:reputations]['reputations'] &&
      response[:equipment] && response[:equipment]['equipped_items']
    end
  end
end
