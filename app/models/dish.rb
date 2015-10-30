class Dish < ActiveRecord::Base
  has_one :picture, as: :assetable, dependent: :destroy
  belongs_to :category

  accepts_nested_attributes_for :picture
end
