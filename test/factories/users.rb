FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "email_#{n}@gmail.com" }
    password 'testingg'
    encrypted_password '$2a$10$Sy7oOQegW5XRtMGrL061zeCGdULyJLAIuj6Wpkyb0R2OCrvGeXeWa'
  end
end
