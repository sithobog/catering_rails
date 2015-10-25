class DailyRation < ActiveRecord::Base
	has_one :sprint
	has_one :daily_menu
	has_one :dish
end
