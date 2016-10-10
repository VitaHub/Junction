FactoryGirl.define do
  factory :message do
    recipient_id 1
    sender_id 1
    conversation_id 1
    body "MyText"
    status 1
  end
  factory :conversation do
    
  end
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