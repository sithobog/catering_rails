module API
	module V1

		autoload :DailyRationQueryHelper, 'v1/helpers/daily_ration_query_helper'

		class DailyRations < Grape::API
			version 'v1'
			format :json

			resource :daily_rations do

			  post do
			  	token = request.headers['X-Auth-Token']
			  	puts "Token is #{token}"
			  	user = User.find_by(authentication_token: token)
			  	puts "That was #{user.id}"
			  	sprint_id = params[:sprint_id]
			  	ar_array = Array.new
			  	params[:days].each do |param|
			  		day = param[0]
			  		param[1].each do |p|
			  			p[1].each do |k,v|
			  				ar_array << {
				  				sprint_id: sprint_id,
				  				day: day,
				  				dish_id: k,
				  				quantity: v
			  				}
			  			end
			  		end
			  	end

					ActiveRecord::Base.transaction do
						ar_array.each do |array|
				  		DailyRation.create(price: 10, quantity: array[:quantity], user_id: user.id,
				  												daily_menu_id: 1, sprint_id: array[:sprint_id], dish_id: array[:dish_id])
				  	end
					end

			  end

				desc "Return dishes from daily_menu sorted by category"
				get do
					DailyRationQueryHelper.new.menu
				end

			end

		end
	end
end
