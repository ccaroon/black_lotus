# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :deck do
    sequence (:name) {|i| "Deck ##{i}"}
    sequence (:format) {|i| %w(Standard Vintage Legacy Commander)[i%4]}
  end
end
