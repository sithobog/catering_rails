module API
  module V1
    class ParamsArray < Grape::API

      attr_reader :params_array

      def initialize(params)
        @params_array = fill_array(params)
      end

      def fill_array(params)
        array_from_params = Array.new
        params.each do |k,v|
          array_from_params << {
            sprint_id: v[:sprint_id],
            daily_menu_id: v[:day_id],
            dish_id: v[:dish_id],
            quantity: v[:quantity],
            price: v[:price],
          }
        end
        array_from_params
      end
    end
  end
end
