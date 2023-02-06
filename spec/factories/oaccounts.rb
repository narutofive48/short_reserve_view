FactoryBot.define do
  factory :oaccount do
    email { Faker::Internet.free_email }
    password { Faker::Internet.password(8) }
    association :office_city
    association :bed_type
    office_phone { Faker::PhoneNumber.phone_number }
    office_bed_count { 10 }
  end
end
