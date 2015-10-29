module API
	module V1

		autoload :DailyMenus, 'v1/resources/daily_menus'
		autoload :Dishes, 'v1/resources/dishes'
		autoload :Sprints, 'v1/resources/sprints'

		class Root < Grape::API
			mount API::V1::Dishes
			mount API::V1::Sprints
			mount API::V1::DailyMenus
		end

	end
end
