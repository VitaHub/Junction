FactoryGirl.define do
  factory :message_status do
    user_id 1
    message_id 1
    status 1
  end
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
    gender 2
		email { Faker::Internet.email }
		password "testpass"
    password_confirmation "testpass"
	end
end