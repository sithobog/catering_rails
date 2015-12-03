autoload :Helpers, 'v1/resources/helpers'
module API
  module V1
    class Sprints < Grape::API
      version 'v1'
      format :json

      resource :sprints do
        desc "Return list of sprints"
        get do 
          authenticate_by_token!
          Sprint.all.where(state: [:running, :closed])
        end

        desc "Return daily ration for specific sprint"
        get "/:id/rations" do
          DailyRation.find_by(sprint_id: params[:id])
        end
      end

    end
  end
end
