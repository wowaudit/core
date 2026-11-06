module Audit
  module ClassicForever
    class GearData < Audit::ClassicEra::GearData
      def item_level(equipped_item)
        equipped_item.dig(:level, :value) || 0
      end
    end
  end
end
