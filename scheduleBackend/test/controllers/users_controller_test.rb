require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should create user" do
    assert_difference('User.count') do
      post users_url, params: { user: { name: 'Test User', email: 'random_test@example.com', password: 'password', password_confirmation: 'password' } }
    end
    assert_response :created
    json_response = JSON.parse(response.body)
    assert_equal 'User created successfully', json_response['message']
  rescue ActiveRecord::RecordInvalid => e
    puts e.record.errors.full_messages
  end

  test "should not create user with invalid data" do
    assert_no_difference('User.count') do
      post users_url, params: { user: { name: '', email: 'invalid', password: 'short', password_confirmation: 'mismatch' } }
    end
    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert_not_empty json_response['errors']
  end

  test "should login user" do
    user = User.create!(name: 'Test User', email: 'unique_test@example.com', password: 'password', password_confirmation: 'password')
    post login_url, params: { email: user.email, password: 'password' }
    assert_response :ok
    json_response = JSON.parse(response.body)
    assert_equal 'Login successful', json_response['message']
  end

  test "should not login user with invalid credentials" do
    post login_url, params: { email: 'nonexistent@example.com', password: 'wrongpassword' }
    assert_response :unauthorized
    json_response = JSON.parse(response.body)
    assert_equal 'Invalid email or password', json_response['message']
  end
end