FactoryBot.define do
  factory :user do
    name { "testuser" }
    email { Faker::Internet.unique.email }
    password { "password123" }
    password_confirmation { "password123" }
  end
end
