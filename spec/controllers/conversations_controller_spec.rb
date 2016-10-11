require 'rails_helper'

RSpec.describe ConversationsController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
    	@request.env["devise.mapping"] = Devise.mappings[:user]
    	user = FactoryGirl.create(:user)
			user.confirmed_at = Time.now
			user.save
			sign_in user
      get :index
      expect(response).to have_http_status(:success)
    end
  end

end
