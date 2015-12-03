module API
  module V1

    autoload :DaysQueryHelper, 'v1/helpers/days_query_helper'

    class Days < Grape::API
      version 'v1'
      format :json

      resource :days do

        desc "Need token", headers: {
          "X-Auth-Token" => {
            description: "User token",
            required: true
          }
        }
        get do
          authenticate_by_token!
          DaysQueryHelper.new.menu
        end

      end

    end
  end
end
