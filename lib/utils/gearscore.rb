# Based on https://github.com/anzz1/TacoTip/blob/master/gearscore.lua

module Audit
  class GearScore
    DEFAULT_SCALE = 1.8618

    # Value for WOTLK
    BRACKET_SIZE = 1000

    SLOT_SCALE = {
      main_hand: 1,
      off_hand: 1,
      head: 1,
      neck: 0.5625,
      shoulder: 0.75,
      back: 0.5625,
      chest: 1,
      wrist: 0.5625,
      hands: 0.75,
      waist: 0.75,
      legs: 1,
      feet: 0.75,
      finger_1: 0.5625,
      finger_2: 0.5625,
      trinket_1: 0.5625,
      trinket_2: 0.5625,
      ranged: 0.3164,
    }

    QUALITY_MODIFIER = {
      POOR:      { A: 73,     B: 1,      SCALE: 0.005 },
      COMMON:    { A: 73,     B: 1,      SCALE: 0.005 },
      UNCOMMON:  { A: 73,     B: 1,      SCALE: 1     },
      RARE:      { A: 81.375, B: 0.8125, SCALE: 1     },
      EPIC:      { A: 91.45,  B: 0.65,   SCALE: 1     },
      LEGENDARY: { A: 91.45,  B: 0.65,   SCALE: 1.3   },
      ARTIFACT:  { A: 91.45,  B: 0.65,   SCALE: 1.3   },
      HEIRLOOM:  { A: 81.375, B: 0.8125, SCALE: 1     },
    }

    # For items with an item level of 120 or less (does the rare A value really make sense?)
    LEGACY_QUALITY_MODIFIER = {
      POOR:      { A: 8,    B: 2,   SCALE: 0.005 },
      COMMON:    { A: 8,    B: 2,   SCALE: 0.005 },
      UNCOMMON:  { A: 8,    B: 2,   SCALE: 1     },
      RARE:      { A: 0.75, B: 1.8, SCALE: 1     },
      EPIC:      { A: 26,   B: 1.2, SCALE: 1     },
      LEGENDARY: { A: 26,   B: 1.2, SCALE: 1.3   },
      ARTIFACT:  { A: 26,   B: 1.2, SCALE: 1.3   },
      HEIRLOOM:  { A: 0.75, B: 1.8, SCALE: 1     },
    }

    def initialize(character, gear)
      @character = character
      @gear = gear
    end

    def total
      ITEMS[:classic_progression].sum do |slot|
        equipped = @gear.select{ |item| item[:slot][:type] == slot.upcase }.first
        score_for_item(slot, equipped)
      end.to_i
    end

    def score_for_item(slot, item)
      return 0 unless item

      quality = item[:quality][:type].to_sym
      item_level = quality == :HEIRLOOM ? 187.05 : item[:level][:value]
      modifier = item_level > 120 ? QUALITY_MODIFIER[quality] : LEGACY_QUALITY_MODIFIER[quality]

      slot_scale = if slot == 'ranged' && @character.data['class'] == 'Hunter'
        0.3164 * 5.3224 # mimics how TipTac calculates it
      elsif ['main_hand', 'off_hand'].include?(slot) && @character.data['class'] == 'Hunter'
        0.3164
      else
        SLOT_SCALE[slot.to_sym]
      end

      if false # two handed weapon main_hand and off hand is not two handed weapon
        slot_scale *= 2
      end

      (((item_level - modifier[:A]) / modifier[:B]) * DEFAULT_SCALE * modifier[:SCALE] * slot_scale).to_i
    end
  end
end
