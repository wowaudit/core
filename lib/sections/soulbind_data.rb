module Audit
  class SoulbindData < Data
    def add
      unless @data[:soulbinds].class == RBattlenet::EmptyHashResult || !@data[:soulbinds]['soulbinds']
        soulbind = @data[:soulbinds]['soulbinds'].select{ |soulbind| soulbind["is_active"] }.first rescue byebug

        if soulbind
          @character.data['current_soulbind'] = SOULBIND_NAME[soulbind["soulbind"]["name"]] || soulbind["soulbind"]["name"]

          conduits_found = 0
          soulbind["traits"].each do |trait|
            next unless socket = trait["conduit_socket"]
            conduits_found += 1

            # Skip empty conduits
            next unless socket["socket"]

            @character.data["conduit_#{conduits_found}_ilvl"] = CONDUIT_RANK_TO_ILVL[socket["socket"]["rank"]]
            @character.data["conduit_#{conduits_found}_id"] = CONDUIT_ID_TO_SPELL[socket["socket"]["conduit"]["id"]]
            @character.data["conduit_#{conduits_found}_name"] = socket["socket"]["conduit"]["name"]
          end

        end
      end
    end
  end
end
