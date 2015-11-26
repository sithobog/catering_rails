module API
	module V1

		class DailyRations < Grape::API
			version 'v1'
			format :json

			resource :daily_rations do

			  post do
			  	#find user
			  	token = request.headers['X-Auth-Token']
			  	user = User.find_by(authentication_token: token)
			  	#create array for saving in DB
			  	ar_array = Array.new
			  	params.each do |k,v|
			  		ar_array << {
			  			sprint_id: v[:sprint_id],
				  		daily_menu_id: v[:day_id],
				  		dish_id: v[:dish_id],
				  		quantity: v[:quantity],
				  		price: v[:price],
			  		}
			  	end

			  	all_days = ar_array.map{|x| x[:daily_menu_id]}
			  	puts "all days are"
			  	puts all_days
			  	puts "unique days are"
			  	puts all_days.uniq
			  	all_dishes = Array.new
			  	ar_array.map do |x|
				  	all_dishes << { 
					  	id: x[:dish_id].to_i,
					  	price: x[:price].to_f
				  	}
				  end
				  #remove duplicates
			  	uniq_dishes = all_dishes.uniq {|h| h[:id]}
			  	#sort array
			  	sorted_uniq_dishes = uniq_dishes.sort_by {|hsh| hsh[:id]}
			  	#grab all unique dish_id
			  	all_dishes_id = ar_array.map{|x| x[:dish_id]}.uniq
			  	#grab only ids and prices of dishes
			  	dishes = Dish.where(id: all_dishes_id).pluck(:id,:price)
			  	#create array for comparison
			  	dishes_from_db = Array.new
			  	dishes.each do |elem|
			  		dishes_from_db <<{
			  			# zero element of array is id, first element is price
			  			id: elem[0],
			  			price: elem[1]
			  		}
			  	end
			  	puts "dishes_from_db is "
			  	puts dishes_from_db
			  	puts "sorted uniq dishes"
			  	puts sorted_uniq_dishes
			  	#comparison of arrays, if true then prices from client are correct
			  	if dishes_from_db == sorted_uniq_dishes
			  		puts "All is good"
			  	else
			  		puts "Prices from client are incorrect"
			  	end

					ActiveRecord::Base.transaction do
						ar_array.each do |array|
				  		DailyRation.create(price: array[:price], quantity: array[:quantity], user_id: user.id,
				  												daily_menu_id: array[:daily_menu_id], sprint_id: array[:sprint_id], dish_id: array[:dish_id])
				  	end
					end

			  end
			end

		end
	end
end
