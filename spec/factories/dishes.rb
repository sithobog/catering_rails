FactoryGirl.define do
  factory :dish do
  	sequence(:title) { |n| "Dish#{n}" }
    description "Amazing soup!"
    price 25
    type "SingleMeal"
    association :category
  end

end
