require "rails_helper"

describe "if user didn't sign in" do
	it "sign up link should be present on main page" do
		visit root_path
		expect(page).to have_selector(:css, ".header a#signup_link")
	end

	it "sign up link should be present on sign in page" do
		visit new_user_session_path
		expect(page).to have_selector(:css, ".header a#signup_link")
	end

	it "sign up link should NOT be present on sign up page" do
		visit new_user_registration_path
		expect(page).not_to have_selector(:css, ".header a#signup_link")
	end
end

describe "if user signed in" do
	it "sign up link should NOT be present on main page" do
		user = FactoryGirl.create(:user)
		user.confirmed_at = Time.now
		user.save
		login_as(user, :scope => :user)
		visit root_path
		expect(page).not_to have_selector(:css, ".header a#signup_link")
	end

	
end