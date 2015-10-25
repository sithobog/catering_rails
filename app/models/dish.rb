class Dish < ActiveRecord::Base
  has_one :picture, as: :assetable, dependent: :destroy
  belongs_to :category
  belongs_to :daily_ration

  accepts_nested_attributes_for :picture
end
