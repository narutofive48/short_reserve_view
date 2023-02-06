FactoryBot.define do
  factory :uaccount do
    email { Faker::Internet.free_email }
    password { Faker::Internet.password(8) }
    user_name { Faker::Name.name }
    user_phone { Faker::PhoneNumber.phone_number }
    confirmed_at { Time.zone.now }
  end
end
