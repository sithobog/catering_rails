module API
	module V1

		class DailyRations < Grape::API
			version 'v1'
			format :json

			resource :daily_rations do

			  post do
			  	token = request.headers['X-Auth-Token']
			  	user = User.find_by(authentication_token: token)
			  	sprint_id = params[:sprint_id]
			  	ar_array = Array.new
			  	params[:days].each do |param|
			  		daily_menu_id = param[0]
			  		param[1].each do |p|
			  			p[1].each do |k,v|
			  				ar_array << {
				  				sprint_id: sprint_id,
				  				daily_menu_id: daily_menu_id,
				  				dish_id: k,
				  				quantity: v
			  				}
			  			end
			  		end
			  	end
			  	dish_ids = Array.new
			  	quantities = Array.new
			  	ar_array.each do |element|
			  		dish_ids << element[:dish_id]
			  		quantities << element[:quantity]
			  	end
			  	puts dish_ids
			  	puts quantities

					ActiveRecord::Base.transaction do
						ar_array.each do |array|
				  		DailyRation.create(price: 10, quantity: array[:quantity], user_id: user.id,
				  												daily_menu_id: array[:daily_menu_id], sprint_id: array[:sprint_id], dish_id: array[:dish_id])
				  	end
					end

			  end
			end

		end
	end
end
