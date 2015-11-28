module API
  module V1
    class DailyRationValidator < Grape::API
      #format :json

      attr_reader :valid

      def initialize(array_from_params)
        @valid = validate_params(array_from_params)
      end

      def validate_params(array_from_params)

        valid_price = validate_price(array_from_params)
        valid_limit = validate_limit(array_from_params)

        valid_price && valid_limit ? true : false
      end

      def validate_price(array_from_params)

        validated = true

        #grab unique days
        all_days = array_from_params.map{|x| x[:daily_menu_id]}.uniq
        all_dishes = Array.new
        array_from_params.map do |x|
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
        all_dishes_id = array_from_params.map{|x| x[:dish_id]}.uniq
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

        #comparison of arrays, if true then prices from client are correct
        if dishes_from_db == sorted_uniq_dishes
          puts "Prices from client are correct"
        else
          puts "Error. Prices from client are incorrect"
          validated = false
          fail Grape::Exceptions::Validation,
                              params: [server_side: dishes_from_db, client_side: sorted_uniq_dishes],
                              message: "Price on client side is wrong"
        end

        return validated
      end

      def validate_limit(array_from_params)

        validated = true

        #grab unique days
        all_days = array_from_params.map{|x| x[:daily_menu_id]}.uniq

        daily_menus = DailyMenu.where(id: all_days).pluck(:id,:max_total).to_h
        day_hash = Hash.new
        array_from_params.each do |elem|
          if !day_hash.key?(elem[:daily_menu_id].to_i)
            day_hash[elem[:daily_menu_id].to_i] = elem[:price].to_f*elem[:quantity].to_f
          else
            day_hash[elem[:daily_menu_id].to_i] += elem[:price].to_f*elem[:quantity].to_f
          end
        end

        result = daily_menus.merge(day_hash){|key,oldval,newval| oldval-newval}
        result.each do |key,value|
          if value<0
            puts "Day #{key} is overlimitted"
            validated = false
            fail Grape::Exceptions::Validation, params: "Day #{key}", message: "Limit for day is outspent"
          end
        end

        return validated
      end

    end
  end
end
