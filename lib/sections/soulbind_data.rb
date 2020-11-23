module Audit
  class SoulbindData < Data
    def add
      # Retrieve conduit ID > spell ID mapping (for spreadsheet ID) from API

      # unless @data[:soulbinds].class == RBattlenet::EmptyHashResult
      @character.data['current_soulbind'] = ''
      @character.data['conduit_1_ilvl'] = ''
      @character.data['conduit_1_id'] = ''
      @character.data['conduit_1_name'] = ''
      @character.data['conduit_2_ilvl'] = ''
      @character.data['conduit_2_id'] = ''
      @character.data['conduit_2_name'] = ''
      @character.data['conduit_3_ilvl'] = ''
      @character.data['conduit_3_id'] = ''
      @character.data['conduit_3_name'] = ''
      # end
    end
  end
end
