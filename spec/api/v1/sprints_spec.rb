require 'rails_helper'
describe API::V1::Root do
  describe "GET /api/v1/sprints" do
    it "returns json of sprint" do
      user = FactoryGirl.create(:user)
      sprint = FactoryGirl.create(:sprint, title: "Let's test it!")

      get "/api/v1/sprints", {}, {'X-Auth-Token' => user.authentication_token}
      expect(response.status).to eq 200
      expect(response.body).to have_node(:title).with("Let's test it!")
    end
  end
end

