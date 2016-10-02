FactoryGirl.define do
	factory :user do
		first_name "UserFirstName"
		last_name "UserLastName"
		email "testuser@test.com"
		password "testpass"
	end
end