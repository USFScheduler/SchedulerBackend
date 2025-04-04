# app/controllers/api/v1/canvas_controller.rb
module Api
  module V1
    class CanvasController < ApplicationController
      # before_action :authenticate_user!
      before_action :set_canvas_service
      
      def courses
        response = @canvas_service.get_courses
        render json: response.parsed_response
      end


      def test_connection
        response = @canvas_service.get_courses
        if response.code == 200
          render json: { status: "success", message: "Canvas API connection successful!", data: response.parsed_response }, status: :ok
        else
          render json: { status: "error", message: "Canvas API connection failed", details: response }, status: :bad_gateway
        end
      end
      
      def assignments
        course_id = params[:course_id]
        response = @canvas_service.get_assignments(course_id)
        render json: response.parsed_response
      end
      
      def upcoming_assignments
        response = @canvas_service.get_upcoming_assignments
        render json: response.parsed_response
      end
      
      def calendar_events
        start_date = params[:start_date] ? Date.parse(params[:start_date]) : Date.today
        end_date = params[:end_date] ? Date.parse(params[:end_date]) : (Date.today + 30)
        
        response = @canvas_service.get_calendar_events(start_date, end_date)
        render json: response.parsed_response
      end
      
      private

      
      def set_canvas_service
        # You might want to store the API token securely in the user model
        # or let the user input it and store it in their session
        # api_token = current_user.canvas_api_token
        api_token = params[:api_token] || ENV['CANVAS_API_TOKEN']
        @canvas_service = CanvasApiService.new(api_token)
      end
    end
  end
end