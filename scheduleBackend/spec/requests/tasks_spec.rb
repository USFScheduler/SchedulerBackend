require 'rails_helper'

RSpec.describe "Tasks API", type: :request do
  describe "POST /tasks" do
    let(:valid_payload) do
      {
        tasks: [
          {
            title: "Event Name",
            start_time: "10:00",
            end_time: "11:00",
            am_start: true,
            am_end: false,
            days_of_week: ["M", "W", "F"]
          }
        ]
      }
    end

    context "when the request is valid" do
      it "creates tasks and returns a success response" do
        post "/tasks", params: valid_payload

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include("message" => "Tasks created successfully")
        expect(JSON.parse(response.body)["tasks"].first).to include(
          "title" => "Event Name",
          "start_time" => "10:00",
          "end_time" => "11:00",
          "am_start" => true,
          "am_end" => false,
          "days_of_week" => ["M", "W", "F"]
        )
      end
    end

    context "when the request is invalid" do
      let(:invalid_payload) { { tasks: [] } }

      it "returns an error response" do
        post "/tasks", params: invalid_payload

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include("errors")
      end
    end
  end

  describe "GET /tasks" do
    before do
      # Use FactoryBot to create a task
      create(:task)
    end

    it "returns a list of tasks" do
      get "/tasks"

      expect(response).to have_http_status(:ok)
      tasks = JSON.parse(response.body)
      expect(tasks.length).to eq(1)
      expect(tasks.first).to include(
        "title" => "Sample Task",
        "start_time" => "09:00",
        "end_time" => "10:00",
        "am_start" => true,
        "am_end" => true,
        "days_of_week" => ["M", "T"]
      )
    end
  end
end