FactoryBot.define do
  factory :city, aliases: [:office_city] do
    city_name { "MyString" }
    association :prefecture
  end
end
