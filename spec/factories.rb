FactoryGirl.define do
  factory :city do
    name "MyString"
    state nil
  end
  factory :state do
    name "MyString"
    country nil
  end
  factory :country do
    name "MyString"
  end
	factory :user do
		first_name "UserFirstName"
		last_name "UserLastName"
		email "testuser@test.com"
		password "testpass"
	end
end