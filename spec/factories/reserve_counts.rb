FactoryBot.define do
  factory :reserve_count do
    date { Time.zone.now.since(10.days) }
  end
end
