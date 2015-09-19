FactoryGirl.define do
  factory :user, aliases: [:author] do
    email { Faker::Internet.safe_email }
    password { Faker::Internet.password }
    name { Faker::Name.name }
    after(:create) {|user| user.confirm }
    factory :grad do
      role :grad
    end
    factory :control do
      role :control
    end
    factory :admin do
      role :admin
    end
  end
end
