# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if Prefecture.all.empty?
  prefectures = ["広島", "岡山", "島根", "山口", "鳥取"]
  prefectures.each do |prefecture|
    Prefecture.create(prefecture: prefecture)
  end
end

if Bedtype.all.empty?
  bedtypes = ["従来型個室", "4人部屋", "2人部屋"]
  bedtypes.each do |bedtype|
    Bedtype.create(bed_type: bedtype)
  end
end

if City.all.empty?
  cities = ["広島市安佐南区", "広島市東区", "広島市南区", "広島市西区"]
  cities.each do |city|
    City.create(city_name: city)
  end
end
if Transfer.all.empty?
  transfers = ["送迎有り", "送迎なし" ]
  transfers.each do |transfer|
    Transfer.create(trans_flg: transfer)
  end
end
if Past.all.empty?
  pasts = ["過去に利用有り", "過去に利用なし" ]
  pasts.each do |past|
    Past.create(past_use: past)
  end
end
if Administrator.all.empty?
  Administrator.create[administrator: "admin@picot.jp", password: "Passw0rd"]
end
