module API
	module V1
		class DailyMenus < Grape::API
			version 'v1'
			format :json

			resource :daily_menus do
				desc "Return list of daily menus"
				get do
					authenticate_by_token!
					DailyMenu.all
				end
			end

		end
	end
end
