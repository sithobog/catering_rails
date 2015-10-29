require 'grape-swagger'

module API
	module V1

		autoload :DailyMenus, 'v1/resources/daily_menus'
		autoload :Dishes, 'v1/resources/dishes'
		autoload :Sprints, 'v1/resources/sprints'

		class Root < Grape::API
			format :json
      default_format :json
      default_error_formatter :json
      content_type :json, "application/json"
			version 'v1', using: :path

			mount API::V1::Dishes
			mount API::V1::Sprints
			mount API::V1::DailyMenus

      get "/" do
        {:timenow => Time.zone.now.to_i }
      end

			add_swagger_documentation base_path: "/api", hide_documentation_path: true, api_version: "v1"
		end



	end
end
