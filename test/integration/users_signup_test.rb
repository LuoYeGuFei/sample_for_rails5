require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
	test "invalid signup information" do
		get signup_path
		assert_no_difference 'User.count' do
			post users_path, params: { user: { name: "",
																 email: "user@example.com",
																 password: "foo",
																 password_confirmation: "bar" }}
		end
		assert_template 'users/new'
		#assert_select 'div#<CSS id for error explanation>'
		#assert_select 'div.<CSS class for field with error>'
	end

	test "valid signup information" do
		get signup_path
		assert_difference 'User.count', 1 do
			post users_path, params: { user: { name: "lyz",
																 email: "df@fdsf.com",
																 password: "password",
																 password_confirmation: "password" }}
		end
		follow_redirect!
		assert_template 'users/show'
		assert is_logged_in?
	end

end
