# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

require 'faker'

# Clear existing data
Task.destroy_all
User.destroy_all

# Create sample users
10.times do
  user = User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: 'password123',
    password_confirmation: 'password123'
  )

  # Create sample tasks for each user
  5.times do
    user.tasks.create!(
      title: Faker::Lorem.sentence(word_count: 3),
      start_date: Faker::Date.backward(days: 30),
      end_date: Faker::Date.forward(days: 30),
      deadline: Faker::Time.forward(days: 30, period: :evening),
      priority: rand(1..5)
    )
  end
end

puts "Seeded #{User.count} users with #{Task.count} tasks."
