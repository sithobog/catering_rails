FactoryGirl.define do
  factory :daily_ration do
    price 25
    quantity 3

    association :daily_menu
    association :sprint
    association :dish
  end
end
