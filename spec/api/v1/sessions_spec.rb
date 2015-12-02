require 'rails_helper'
describe API::V1::Root do
  describe "POST /api/v1/sessions" do
    let!(:user) { FactoryGirl.create(:user) }
    context 'POST /sessions' do
      it "gives user authentication info" do
        
        post "/api/v1/sessions", {email: user.email, password: user.password}
        expect(response.status).to eq 201
        expect(response.body).to have_node(:auth).with(true)
        expect(response.body).to have_node(:token).with(user.authentication_token)
        expect(response.body).to have_node(:name).with(user.name)
      end

      it 'return error for wrong email' do
        post "/api/v1/sessions", {email: "wrong_email", password: user.password}
        expect(response.status).to eq 422
        expect(response.body).to have_node(:error_message).with("Email is wrong.")
      end

      it 'return error for wrong password' do
        post "/api/v1/sessions", {email: user.email, password: "wrong_password"}
        expect(response.status).to eq 422
        expect(response.body).to have_node(:error_message).with("Password is wrong.")
      end

      it 'return error if email/password is missing' do
        post "/api/v1/sessions", {email: nil, password: nil}
        expect(response.status).to eq 422
        expect(response.body).to have_node(:error_message).with("Invalid Email or Password.")
      end
    end

    context 'DELETE /sessions' do
      it "reset authentication token" do
        delete "/api/v1/sessions", {}, {'X-Auth-Token' => user.authentication_token}

        #can't find user with old token, because token has been reseted
        
        empty_user = User.where(authentication_token: user.authentication_token).first
        expect(empty_user).to equal(nil)
      end
    end


  end
end

