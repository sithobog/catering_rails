class DailyMenu < ActiveRecord::Base
	has_many :daily_rations
end
