FactoryGirl.define do
	factory :user do
		name 				"Eric Haydel"
		email 			"erichaydel@gmail.com"
		password 		"foobar"
		password_confirmation "foobar"
	end
end