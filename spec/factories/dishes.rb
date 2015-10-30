FactoryGirl.define do
  factory :dish do
    title "Borshik"
    description "Amazing soup!"
    price 25
    association :category
  end

end
