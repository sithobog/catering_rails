module API
	module V1
		class Dishes < Grape::API
			version 'v1'
			format :json

			resource :dishes do
				desc "Return list of recent dishes"
				get do 
					Dish.all
				end
			end
			
		end
	end
end
