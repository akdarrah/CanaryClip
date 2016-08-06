FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "email_#{n}@gmail.com" }
  end
end
