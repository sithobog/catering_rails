module API
	module V1
		class DaysQueryHelper
			#format :json

			attr_reader :menu

			def initialize
				@menu = get_menu
			end

			def get_menu
				_menus = DailyMenu.all.as_json(except: [:created_at, :updated_at])
				_categories_from_query = Category.all
				_menus.each do |menu|
					_categories = _categories_from_query.as_json(except: [:created_at, :updated_at])
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
