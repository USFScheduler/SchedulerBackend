# test/controllers/api/v1/canvas_controller_test.rb
require "test_helper"

class Api::V1::CanvasControllerTest < ActionDispatch::IntegrationTest
  # A simple fake response to mimic HTTParty responses.
  class FakeResponse
    attr_reader :code, :parsed_response

    def initialize(code, parsed_response)
      @code = code
      @parsed_response = parsed_response
    end
  end

  # A fake Canvas API service for testing purposes.
  class FakeCanvasApiService
    # Placeholder methods. We’ll override these in the tests.
    def get_courses; end
    def get_upcoming_assignments; end
  end

  test "test_connection returns success when API returns 200" do
    fake_api_token = "fake_token"
    # Define a fake service that returns a successful response.
    fake_service = FakeCanvasApiService.new
    def fake_service.get_courses
      FakeResponse.new(200, {"courses" => ["Course A", "Course B"]})
    end

    # Stub the instantiation of CanvasApiService to return our fake_service.
    CanvasApiService.stub :new, fake_service do
      # Use the named route helper based on your routes.
      get test_connection_api_v1_canvas_url, params: { api_token: fake_api_token }
      assert_response :success

      body = JSON.parse(response.body)
      assert_equal "success", body["status"]
      assert_equal "Canvas API connection successful!", body["message"]
      assert_equal({"courses" => ["Course A", "Course B"]}, body["data"])
    end
  end

  test "test_connection returns error when API returns non-200" do
    fake_api_token = "fake_token"
    # Define a fake service that returns an error response.
    fake_service = FakeCanvasApiService.new
    def fake_service.get_courses
      FakeResponse.new(500, {})
    end

    CanvasApiService.stub :new, fake_service do
      get test_connection_api_v1_canvas_url, params: { api_token: fake_api_token }
      assert_response :bad_gateway

      body = JSON.parse(response.body)
      assert_equal "error", body["status"]
      assert_equal "Canvas API connection failed", body["message"]
    end
  end

  test "upcoming_assignments returns error when API returns non-200" do
    fake_api_token = "fake_token"
    fake_service = FakeCanvasApiService.new
    def fake_service.get_upcoming_assignments
      FakeResponse.new(500, {})
    end

    CanvasApiService.stub :new, fake_service do
      get upcoming_assignments_api_v1_canvas_url, params: { api_token: fake_api_token }
      assert_response :bad_gateway

      body = JSON.parse(response.body)
      assert_equal "Failed to fetch assignments", body["error"]
      assert_equal 500, body["status"]
    end
  end
end
