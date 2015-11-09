module API
	module V1

		autoload :DailyRationQueryHelper, 'v1/helpers/daily_ration_query_helper'

		class DailyRations < Grape::API
			version 'v1'
			format :json

			resource :daily_rations do

				#desc "Create daily_rations from params"
			  #params do
			  #end

				desc "Return dishes from daily_menu sorted by category"
				get do
					DailyRationQueryHelper.new.menu
				end

			end

		end
	end
end
