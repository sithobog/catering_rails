module API
  module V1

    autoload :OrderHelper, 'v1/helpers/order_helper'

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
          authenticate_by_token!
          sprint = request.headers['X-Sprint']
          user = current_user

          rations = DailyRation.includes(:dish,:daily_menu).where(user_id: user.id, sprint_id: sprint)
          #return hash with daily_menu, dishes and children dishes
          new_rations = OrderHelper.new(rations).rations_hash

          grouped_rations = new_rations.group_by {|elem| elem[:day_number]}

        end
      end
    end
  end
end
