FactoryGirl.define do
  factory :question do
    author
    text { Faker::Lorem.sentence }
  end
end
