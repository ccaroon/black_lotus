
FactoryGirl.define do
  factory :edition, :class => 'Edition' do
    sequence(:name) {|i| "Edition ##{i}" }
    code_name { name[0..1] + name[9..-1] }
    online_code { code_name.downcase }
    card_count 125
    release_date "1995-01-01"
  end
end
