FactoryGirl.define do
  factory :daily_menu do

  	sequence(:day_number) { |n| n }
  	max_total 140
  	dish_ids [1,2,3]
    
  end

end
