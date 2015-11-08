module API
	module V1
		class DailyRations < Grape::API
			version 'v1'
			format :json

			resource :daily_rations do

				desc "Return dishes from daily_menu sorted by category"
				get do
					_menus = DailyMenu.all.as_json(except: [:created_at, :updated_at])

					_menus.each do |menu|
						_categories = Category.all.as_json(except: [:created_at, :updated_at])
						_dishes = Dish.find(menu['dish_ids'])
						_grouped_dishes = _dishes.group_by {|x| x['category_id']}
						menu['categories'] = _categories

						menu['categories'].each do |category|
							category['dishes'] = _grouped_dishes[category['id']].as_json(except: [:sort_order, :created_at, :updated_at])
						end
						#delete categories from JSON if it hasn't dishes
						menu['categories'].reject! { |cat| !cat['dishes'] }
						menu.delete('dish_ids')

					end

				end

			end

		end
	end
end
