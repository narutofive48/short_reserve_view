class City < ApplicationRecord
 belongs_to :prefecture
 def full_name
  prefecture.prefecture + city_name 
 end
end
