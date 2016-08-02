FactoryGirl.define do
  factory :character do
    sequence(:username) {|n| "user_#{n}" }
    uuid { UUID.generate }
  end
end
