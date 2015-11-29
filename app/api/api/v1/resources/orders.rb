module API
  module V1

    class Orders < Grape::API
      version 'v1'
      format :json

      resource :orders do

        desc "Need token", headers: {
          "X-Auth-Token" => {
            description: "User token",
            required: true
          },
          "X-Sprint" => {
            description: "Sprint id",
            required: true
          }
        }

        get do
          #find user
          token = request.headers['X-Auth-Token']
          sprint = request.headers['X-Sprint']
          puts "SPRINT IS"
          puts sprint
          user = User.find_by(authentication_token: token)

          rations = DailyRation.includes(:dish,:daily_menu).where(user_id: user.id, sprint_id: sprint)

          puts "rations is "
          new_rations = Array.new
          rations.each do |ration|
            daily_menu = { day_number: ration.daily_menu.day_number}

            if ration.dish.type == "BusinessLunch"
              children = Dish.find(ration.dish.children_ids).as_json(only: [:id, :title])
            end
            dish_children = {children: children}

            dish = { title: ration.dish.title, description: ration.dish.description}
            ration = ration.as_json(except: [:id, :user_id, :daily_menu_id, :sprint_id, :created_at, :updated_at,:dish_id])



            new_rations << ration.merge(daily_menu).merge(dish).merge(dish_children)
          end
          grouped_rations = new_rations.group_by {|elem| elem[:day_number]}

        end
      end

    end
  end
end
