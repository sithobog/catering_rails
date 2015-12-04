require 'grape-swagger'

module API
  module V1

    autoload :Sprints, 'v1/resources/sprints'
    autoload :Helpers, 'v1/resources/helpers'
    autoload :Sessions, 'v1/resources/sessions'
    autoload :DailyRations, 'v1/resources/daily_rations'
    autoload :Days, 'v1/resources/days'
    autoload :Orders, 'v1/resources/orders'

    class Root < Grape::API
      format :json
      default_format :json
      default_error_formatter :json
      content_type :json, "application/json"
      version 'v1', using: :path

      helpers API::V1::Helpers

      mount API::V1::Sprints
      mount API::V1::Sessions
      mount API::V1::DailyRations
      mount API::V1::Days
      mount API::V1::Orders

      get "/" do
        {:timenow => Time.zone.now.to_i }
      end

      add_swagger_documentation base_path: "/api", hide_documentation_path: true, api_version: "v1"
    end



  end
end
