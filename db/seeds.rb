require 'faker'

# Create Tags
tags = 10.times.map do
  tag = Tag.create!(name: Faker::Hobby.activity)
  puts "Created Tag: #{tag.name}"
  tag
end

# 定義開始時間跟結束時間(為了不建立錯誤時間導致表單驗證錯誤)
def generate_times
  start_time = Faker::Time.forward(days: rand(1..5), period: :morning)
  end_time = start_time + rand(1..5).hours
  [start_time, end_time]
end

# 建立 5 位 admin 使用者
5.times do
  user = User.create!(
    email: Faker::Internet.unique.email,
    password: 'password',
    password_confirmation: 'password',
    role: 'admin'
  )
  puts "Created Admin User: #{user.email}"

  # 每位 admin 使用者建立 15 筆任務
  15.times do
    start_time, end_time = generate_times
    task = user.tasks.create!(
      title: Faker::Lorem.sentence(word_count: 3),
      content: Faker::Lorem.paragraph,
      start_time: start_time,
      end_time: end_time,
      priority: Task.priorities.keys.sample,
      status: Task.statuses.keys.sample
    )

    # 隨機分配標籤
    assigned_tags = tags.sample(rand(1..3))
    task.tags << assigned_tags
    puts "Created Task: #{task.title} for Admin User: #{user.email} with Tags: #{assigned_tags.map(&:name).join(', ')}"
  end
end

# 建立 10 位普通使用者
10.times do
  user = User.create!(
    email: Faker::Internet.unique.email,
    password: 'password',
    password_confirmation: 'password',
    role: 'user'
  )
  puts "Created Regular User: #{user.email}"

  # 每位普通使用者建立 15 筆任務
  15.times do
    start_time, end_time = generate_times
    task = user.tasks.create!(
      title: Faker::Lorem.sentence(word_count: 3),
      content: Faker::Lorem.paragraph,
      start_time: start_time,
      end_time: end_time,
      priority: Task.priorities.keys.sample,
      status: Task.statuses.keys.sample
    )

    # 隨機分配標籤
    assigned_tags = tags.sample(rand(1..3))
    task.tags << assigned_tags
    puts "Created Task: #{task.title} for Regular User: #{user.email} with Tags: #{assigned_tags.map(&:name).join(', ')}"
  end
end

puts "Seed data created successfully!"
