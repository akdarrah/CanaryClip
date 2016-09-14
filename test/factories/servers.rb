FactoryGirl.define do
  factory :server do
    sequence(:name) {|n| "Server ##{n}" }
    association :owner_user, :factory => :user
    sequence(:hostname) {|n| "86.148.205.#{n}" }
  end
end
