require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
	def setup
		@user = User.new(name: "Exemple User", email: "user@example.com",
										password: "foo123", password_confirmation: "foo123")
	end

	test "should be valid" do
		assert @user.valid?
	end

	test "name should not be blank" do
		@user.name = ""
		assert_not @user.valid?
	end

	test "eamil should not be blank" do
		@user.email = ""
		assert_not @user.valid?
	end

	test "name should't be too long" do
		@user.name = "a" * 50
		assert_not @user.valid?
	end

	test "email validation should accept valid addresses" do
		valid_addresses = %w[user@example.com lfdgd@qq.com dfds@fdg.com
			first.last.@dfs.com]
		valid_addresses.each do |valid_add|
			@user.email = valid_add
			assert @user.valid?, "#{valid_add} should be invalid"
		end
	end

	test "email addresses should be unique" do
		duplicate_user = @user.dup
		duplicate_user.email = @user.email.upcase
		@user.save
		assert_not duplicate_user.valid?
	end

	test "email addresses should be saved as lower-case" do
		mixed_case_email = "Foo@ExAMPLE.Com"
		@user.email = mixed_case_email
		@user.save
		assert_equal mixed_case_email.downcase, @user.reload.email
	end

	test "password should not be blank" do
		@user.password = @user.password_confirmation = " " * 6
		assert_not @user.valid?
	end

	test "password should have a minimum length" do
		@user.password = @user.password_confirmation = "a" * 5
		assert_not @user.valid?
	end

	test "authenticated? should return false for a user with nil digest" do
		assert_not @user.authenticated?(:remember, '')
	end
end
