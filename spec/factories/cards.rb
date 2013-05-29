
FactoryGirl.define do
  factory :card do
    sequence (:name) { |i| "Card #{i}" }
    sequence (:main_type) {|i| Card::CARD_TYPES.values[i%10]}
    sequence (:sub_type) {|i| %w(Dragon Fish Beast Siren Human Vampire Werewolf Bird Elemental Spirit)[i%10] }
    sequence (:rarity) {|i| Card::RARITIES[i%4]}
    mana_cost "G"
    foil false
    count { rand 999 + 1 }
    editions { FactoryGirl.build_list(:edition, 2) }
  end
end
