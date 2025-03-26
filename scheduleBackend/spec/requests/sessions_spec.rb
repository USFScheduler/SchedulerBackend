require 'rails_helper'
# We are testing the login functionality of the User model with RSpec, simulating API requests to the server.
RSpec.describe "User Login API", type: :request do
  let!(:user) { create(:user) }  # Creates a user before running tests

  describe "POST /login" do
    context "with valid credentials" do
      it "logs in successfully and returns user data" do
        post "/login", params: { name: user.name, password: "password123" }, as: :json # Sends a POST request to the server with the user's name and password

        # puts "Response body: #{response.body}"  # Debugging line


        expect(response).to have_http_status(:ok) # Expects the response status to be 200
        expect(json["message"]).to eq("Login successful") # Expects the response message to be "Login successful"
      end
    end

    context "with invalid credentials" do
      it "returns unauthorized error" do
        post "/login", params: { name: user.name, password: "wrongpassword" }, as: :json # Sends a POST request to the server with the user's name and an incorrect password
        # puts "Response body2: #{response.body}"  # Debugging line

        expect(response).to have_http_status(:unauthorized) # Expects the response status to be 401
        expect(json["message"]).to eq("Invalid email or password") # Expects the response message to be "Invalid email or password"
      end
    end
  end

  # Helper to parse JSON response
  def json
    JSON.parse(response.body) 
  end
end
