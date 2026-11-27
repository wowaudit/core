module Audit
  module ClassicForever
    class GearData < Audit::ClassicEra::GearData
      def item_level(equipped_item)
        equipped_item.dig(:level, :value) || ItemLevels.lookup(@realm.game_version, equipped_item[:item][:id]) || 0
      end
    end
  end
end
