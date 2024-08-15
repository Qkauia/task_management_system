FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }
    password_salt { SecureRandom.hex(16) }
    password_hash { Digest::SHA2.hexdigest("password" + password_salt) }
    role { 'user' }
  end

  trait :admin do
    role { 'admin' }
  end

  trait :deleted do
    deleted_at { Time.current }
  end
end
