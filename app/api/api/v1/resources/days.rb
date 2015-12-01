module API
	module V1

		autoload :DaysQueryHelper, 'v1/helpers/days_query_helper'

		class Days < Grape::API
			version 'v1'
			format :json

			resource :days do

				desc "Return dishes from daily_menu sorted by category"
				get do
					authenticate_by_token!
					DaysQueryHelper.new.menu
				end

			end

		end
	end
end
