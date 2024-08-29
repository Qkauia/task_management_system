# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    start_time { Time.zone.now }
    end_time { Time.zone.now + 1.hour }
    priority { :low }
    status { :pending }
    association :user
  end
end
