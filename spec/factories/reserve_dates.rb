FactoryBot.define do
  factory :reserve_date do
    association :oaccount
    association :start_transfer
    association :end_transfer
    association :past_use
    start_date { Time.zone.now.since(10.days) }
    end_date { Time.zone.now.since(20.days) }
  end
end
