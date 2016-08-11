require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
	
	def setup
		@admin_user = users(:michael)
		@other_user = users(:archer)
	end

	test "index including pagination" do
		log_in_as(@admin_user)
		get users_path
		assert_template 'users/index'
		assert_select 'div.pagination'
		User.paginate(page: 1).per_page(10).each do |user|
			assert_select 'a[href=?]', user_path(user), text: user.name
			unless user == @admin_user
				assert_select 'a[href=?]', user_path(user), text: 'delete'
			end
		end
		assert_difference 'User.count', -1 do
			delete user_path(@other_user)
		end
	end

	test "index as other_user" do
		log_in_as(@other_user)
		get users_path
		assert_select 'a', text: 'delete', count: 0
	end

end
