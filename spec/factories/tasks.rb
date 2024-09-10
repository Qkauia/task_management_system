# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    title { 'Test Task' }
    content { Faker::Lorem.paragraph(sentence_count: 2) }
    start_time { Faker::Time.forward(days: 1, period: :morning) }
    end_time { Faker::Time.forward(days: 2, period: :afternoon) }
    priority { :medium }
    status { :pending }
    important { Faker::Boolean.boolean }
    association :user

    trait :high_priority do
      priority { :high }
    end

    trait :completed do
      status { :completed }
    end

    trait :with_file do
      after(:build) do |task|
        task.file.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'example.txt')),
          filename: 'example.txt',
          content_type: 'text/plain'
        )
      end
    end
  end
end
