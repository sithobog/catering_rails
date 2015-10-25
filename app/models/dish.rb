class Dish < ActiveRecord::Base
  has_one :picture, as: :assetable, dependent: :destroy
  belongs_to :category
  has_many :daily_rations
end
