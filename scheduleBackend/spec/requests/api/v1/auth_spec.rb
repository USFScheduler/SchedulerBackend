require 'rails_helper'

RSpec.describe "Auth", type: :request do
  let!(:user) { User.create!(name: "TestUser", password: "password123", email: "test@example.com") }

  describe "POST /api/v1/login" do
    it "returns access and refresh tokens for valid credentials" do
      post "/api/v1/login", params: { name: "TestUser", password: "password123" }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["access_token"]).to be_present
      expect(json["refresh_token"]).to be_present
      expect(json["user"]["name"]).to eq("TestUser")
    end

    it "rejects invalid credentials" do
      post "/api/v1/login", params: { name: "WrongUser", password: "wrongpass" }

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)["error"]).to eq("Invalid credentials")
    end
  end

  describe "GET /api/v1/tasks (protected)" do
    it "rejects access without token" do
      get "/api/v1/tasks"
      expect(response).to have_http_status(:unauthorized)
    end

    it "allows access with valid token" do
      post "/api/v1/login", params: { name: "TestUser", password: "password123" }
      token = JSON.parse(response.body)["access_token"]

      get "/api/v1/tasks", headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
    end
  end
end
