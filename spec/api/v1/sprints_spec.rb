require 'rails_helper'
describe API::V1::Root do
  describe "GET /api/v1/sprints" do

    it "returns json of sprint" do

      sprint = FactoryGirl.create(:sprint, title: "Let's test it!")

      get "/api/v1/sprints"
      expect(response.status).to eq 200
      expect(response.body).to have_node(:title).with("Let's test it!")
    end

    it "returns rations for specific sprint" do
      
      sprint = FactoryGirl.create(:sprint)
      daily_rations = FactoryGirl.create(:daily_ration, sprint_id: sprint.id, price: 100500)

      get "/api/v1/sprints/#{sprint.id}/rations"
      expect(response.status).to eq 200
      expect(response.body).to have_node(:sprint_id).with(sprint.id)
      expect(response.body).to have_node(:price).with(100500)


    end

  end
end

