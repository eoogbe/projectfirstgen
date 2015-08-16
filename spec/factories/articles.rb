FactoryGirl.define do
  factory :article do
    title { Faker::Lorem.sentence }
    text { Faker::Lorem.paragraphs(3).join("\n") }
    status :approved
    author
  end
end
