require 'rails_helper'
describe API::V1::Root do
  describe "POST /api/v1/daily_rations" do

    let!(:user) { FactoryGirl.create(:user) }
    let!(:sprint) {FactoryGirl.create(:sprint, title: "Let's test it!")}
    let!(:dish1) { FactoryGirl.create(:dish, id: 1, price: 55) }
    let!(:dish2) { FactoryGirl.create(:dish, id: 2, price: 100) }
    let!(:daily_menu_1) { FactoryGirl.create(:daily_menu, max_total: 300) }
    let!(:daily_menu_2) { FactoryGirl.create(:daily_menu, max_total: 400) }

    #key in hashes like '0','1' and etc. means day_number

    #valid hash for create
    hash_for_create = {"0":{sprint_id: 2, day_id: 1, dish_id: 1, quantity: 4, price: 55},
            "1":{sprint_id: 2, day_id: 2, dish_id: 2, quantity: 1, price: 100} }
    #hash where total_price > max_total
    outspent_hash = {"0":{sprint_id: 2, day_id: 1, dish_id: 1, quantity: 100500, price: 55}}
    #hash with different price from server
    wrong_price_hash = {"0":{sprint_id: 2, day_id: 1, dish_id: 1, quantity: 1, price: 100500}}

    context  "POST /daily_rations" do

      it "raise error if limit for day is outspent" do
        post "/api/v1/daily_rations", outspent_hash, {'X-Auth-Token' => user.authentication_token}
        expect(response.status).to eq 422
        expect(response.body).to have_node(:errors).with("Limit for day is outspent")
      end


      it "create daily_rations" do 
        post "/api/v1/daily_rations", hash_for_create, {'X-Auth-Token' => user.authentication_token}
        expect(response.status).to eq 201 
        #create 2 DailyRation records
        expect(DailyRation.all.count).to equal(2)
      end

  
      it "raise error if client's price is wrong" do
        post "/api/v1/daily_rations", wrong_price_hash, {'X-Auth-Token' => user.authentication_token}
        expect(response.status).to eq 422
        expect(response.body).to have_node(:errors).with("Price on client side is wrong")
        expect(response.body).to have_node(:server_side)
        expect(response.body).to have_node(:client_side)
      end
    end
  end
end
