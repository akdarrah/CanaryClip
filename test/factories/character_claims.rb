FactoryGirl.define do
  factory :character_claim do
    user
    character nil
    sequence(:character_username) {|n| "user_#{n}" }
  end
end
