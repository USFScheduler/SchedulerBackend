require "test_helper"

class Api::V1::CanvasControllerLiveTest < ActionDispatch::IntegrationTest
  test "actual connection returns success when Canvas API is reachable" do
    valid_api_token = ENV["CANVAS_API_TOKEN"]
    skip "Skipping live test: No Canvas API token provided" unless valid_api_token.present?

    # Call the controller action using the named route.
    get test_connection_api_v1_canvas_url, params: { api_token: valid_api_token }
    
    # Expect a success response (HTTP 200).
    assert_response :success

    # Parse and verify the response body.
    body = JSON.parse(response.body)
    assert_equal "success", body["status"]
    assert_equal "Canvas API connection successful!", body["message"]
    # Optionally check the structure of the data returned. For example:
    assert_instance_of Array, body["data"]
    # Further assertions can be added based on the expected courses data.
  end

  test "actual connection returns error when Canvas API is unreachable" do
    non_valid_api_token = "invalid_token"
    skip "Skipping live test: No Canvas API token provided" unless non_valid_api_token.present?
    # Call the controller action using the named route.
    get test_connection_api_v1_canvas_url, params: { api_token: non_valid_api_token }
    
    # Expect a failure response (HTTP 502 Bad Gateway).
    assert_response :bad_gateway

    # Parse and verify the response body.
    body = JSON.parse(response.body)
    assert_equal "error", body["status"]
    assert_equal "Canvas API connection failed", body["message"]
  end
end
