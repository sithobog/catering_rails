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

					_grouped_dishes = _grouped_dishes.as_json(except: [:sort_order, :created_at, :updated_at])

					#add dishes title for children_ids
					_grouped_dishes.each do |key,value|
						value.each do |dish|
							if !dish["children_ids"].nil?
								child_dishes = Dish.find(dish["children_ids"]).as_json(only: [:id, :title])
								dish["children"] = child_dishes
								dish.delete("children_ids")
								dish["type"] = "BusinessLunch"
							else
								dish["type"] = "SingleMeal"
							end
						end
					end

					menu['categories'] = _categories

					menu['categories'].each do |category|
						category['dishes'] = _grouped_dishes[category['id'].to_s]
					end

					#delete categories from JSON if it hasn't dishes
					menu['categories'].reject! { |cat| !cat['dishes'] }
					menu.delete('dish_ids')
				end
			end

		end
	end
end
