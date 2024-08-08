FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    start_time { Time.now }
    end_time { Time.now + 1.hour }
    priority { :low }
    status { :pending }
    association :user
  end
end
