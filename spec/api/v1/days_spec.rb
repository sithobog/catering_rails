require 'rails_helper'
describe API::V1::Root do
  describe "GET /api/v1/days" do
    it "returns json of days" do

      user = FactoryGirl.create(:user)
      sprint = FactoryGirl.create(:sprint, title: "Let's test it!")
      daily_menu = FactoryGirl.create(:daily_menu, day_number: 3)
      dish1, dish2, dish3 = FactoryGirl.create(:dish, category_id: 1), FactoryGirl.create(:dish, category_id: 2),
                            FactoryGirl.create(:dish, category_id: 3)
      category1, category2, category3 = FactoryGirl.create(:category), FactoryGirl.create(:category), FactoryGirl.create(:category, title: "Category3")


      get "/api/v1/days", {}, {'X-Auth-Token' => user.authentication_token}
      expect(response.status).to eq 200
      expect(response.body).to have_node(:day_number).with(3)
      expect(response.body).to have_node(:dishes)
      expect(response.body).to have_node(:title).with("Category3")
    end
  end
end

