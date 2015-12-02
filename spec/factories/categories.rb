FactoryGirl.define do
  factory :category do
    sequence(:title) { |n| "Category#{n}" }
    sort_order 1
  end

end
