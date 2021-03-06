require 'populator'
require 'faker'

namespace :populate do
  desc 'Create random categories'
  task categories: [:environment] do
    Category.populate(2..5) do |category|
      category.title = Faker::Lorem.word
    end
  end

  desc 'Create random single_meal'
  task single_meal: [:environment] do
    _categories = Category.all.pluck(:id)
    SingleMeal.populate(20..30) do |meal|
      meal.title = Faker::Book.title
      meal.description = Faker::Lorem.sentence(5)
      meal.price = rand(100)
      meal.type = 'SingleMeal'
      meal.category_id = _categories.sample 1
    end
  end

  desc 'Create random business lunch'
  task bussines_lunch: [:environment] do
    _number = 0
    _categories = Category.all.pluck(:id)
    _meals = SingleMeal.all.pluck(:id, :price)
    BusinessLunch.populate 7 do |bd|
      bd.title = Faker::Book.title
      bd.description = Faker::Lorem.sentence(5)
      bd.type = 'BusinessLunch'
      bd.category_id = _categories.sample 1
      # Select 5 random
      _selected_meals = _meals.sample(rand(3..5))
      # Sum up their prices
      bd.price =  _selected_meals.reduce(0) { |m,i| m += i[1] }
      # Wrap their id's
      bd.children_ids = convert_to_pg_array _selected_meals.map { |i| i[0] }
    end
  end

  desc 'Create random sprints'
  task sprints: [:environment] do
    _number = 0
    Sprint.populate 4 do |sprint|
      sprint.state = 'pending'
      sprint.started_at = Date.commercial(2015, 44 + _number)
      # Add one week
      _number +=1
      sprint.finished_at = Date.commercial(2015, 44 + _number)
      sprint.title = "Sprint # #{_number}"
    end
    # Need to instantinate for some reason
    _temp = Sprint.where(state: "pending").first(2)
    _temp.map {|x| x.run}
    _temp.map {|y| y.save}
    _closed = Sprint.where(state: "running").first
    _closed.close
    _closed.save
  end

  desc 'Create random daily menus'
  task daily_menus: [:environment] do
    _number = 0
    _dishes = Dish.all.pluck(:id)
    DailyMenu.populate 7 do |dm|
      dm.day_number = _number
      dm.dish_ids = convert_to_pg_array _dishes.sample 15
      dm.max_total = 100..150
      _number +=1
    end
  end

  desc 'Create random users'
  task users: [:environment] do
    password = '123456789'
    User.populate(2..5) do |user|
      user.email = Faker::Internet.safe_email
      user.name = Faker::Name.name
      user.encrypted_password = password
      user.sign_in_count = 0
      user.authentication_token = Faker::Internet.password(15)
    end
  end

  desc 'Create random daily rations'
  task :daily_rations => [:environment] do
    _users = User.all.pluck(:id)
    _sprint = Sprint.first
    _daily_menu = DailyMenu.all
    _dishes = Dish.all.pluck(:id, :price)
    _users.each do |_user|
      _daily_menu.each do |dm|
        _dish_ids = dm.dish_ids.sample 3
        DailyRation.populate 3 do |dr|
          dr.quantity = 1..3
          dr.user_id = _user
          dr.daily_menu_id = dm.id
          dr.sprint_id = _sprint.id
          dr.dish_id = _dish_ids.pop
          dr.price = find_price(_dishes, dr.dish_id)
        end
      end
    end
  end

  desc 'Create categories, meals, bussines lunches, sprints, daily menus, users'
  task :all => [:environment] do
    Rake::Task['populate:categories'].invoke
    p 'Categories done'
    Rake::Task['populate:single_meal'].invoke
    p 'Single meals done'
    Rake::Task['populate:bussines_lunch'].invoke
    p 'Bussines lunches done'
    Rake::Task['populate:sprints'].invoke
    p 'Sprints done'
    Rake::Task['populate:daily_menus'].invoke
    p 'Daily menus done'
    Rake::Task['populate:users'].invoke
    p 'Users done'
    Rake::Task['populate:daily_rations'].invoke
    p 'Daily rations done'
  end

  def convert_to_pg_array(array)
    array.to_s.tr('[', '{').tr(']', '}')
  end

  def find_price(array, id)
    array.detect { |i| i[0] == id }
  end
end
