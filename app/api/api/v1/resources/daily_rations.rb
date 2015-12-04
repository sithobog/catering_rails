module API
  module V1

    autoload :DailyRationValidator, 'v1/helpers/daily_ration_validator'
    autoload :ParamsArray, 'v1/helpers/params_array'

    class DailyRations < Grape::API
      version 'v1'
      format :json

      resource :daily_rations do

        post do
          authenticate_by_token!
          user = current_user
          #create array for saving in DB
          array_from_params = ParamsArray.new(params).params_array

          valid = DailyRationValidator.new(array_from_params).valid

          if valid
            puts "Validation completed successful"
            ActiveRecord::Base.transaction do
              array_from_params.each do |array|
                DailyRation.create(price: array[:price], quantity: array[:quantity], user_id: user.id,
                                    daily_menu_id: array[:daily_menu_id], sprint_id: array[:sprint_id], dish_id: array[:dish_id])
              end
            end
          end
        end
      end
    end
  end
end
