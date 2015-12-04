module API
  module V1
    class OrderHelper < Grape::API

      attr_reader :rations_hash

      def initialize(rations)
        @rations_hash = create_hash(rations)
      end

      def create_hash(rations)
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
        new_rations
      end  
    end
  end
end
