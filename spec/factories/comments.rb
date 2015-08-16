FactoryGirl.define do
  factory :comment do
    text { Faker::Lorem.sentence }
    author
    article
    status :approved
  end
end
