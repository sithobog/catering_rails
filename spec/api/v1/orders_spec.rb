require 'rails_helper'
describe API::V1::Root do
  describe "GET /api/v1/orders" do
    it "returns json of orders" do

      user = FactoryGirl.create(:user)
      sprint = FactoryGirl.create(:sprint, title: "Let's test it!")
      daily_menu = FactoryGirl.create(:daily_menu, day_number: 0)
      ration = FactoryGirl.create(:daily_ration, dish_id: 1, daily_menu_id: 1, user_id: user.id, sprint_id: sprint.id)
      dish = FactoryGirl.create(:dish, title: "Dish1")


      get "/api/v1/orders", {}, {'X-Auth-Token' => user.authentication_token, 'X-Sprint' => sprint.id}
      expect(response.status).to eq 200
      expect(response.body).to have_node(:day_number).with(0)
      expect(response.body).to have_node(:title).with("Dish1")
    end
  end
end

