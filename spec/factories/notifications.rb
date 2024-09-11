# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    association :user
    association :task
    message { Faker::Lorem.sentence(word_count: 5) }
    created_at { Time.current }
    updated_at { Time.current }
  end
end
