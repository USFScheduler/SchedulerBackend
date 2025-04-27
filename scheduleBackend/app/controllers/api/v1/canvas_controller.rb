# app/controllers/api/v1/canvas_controller.rb
module Api
  module V1
    class CanvasController < ApplicationController
      before_action :set_canvas_service
      
      # def courses
      #   response = @canvas_service.get_courses
      #   render json: response.parsed_response
      # end


      def test_connection
        response = @canvas_service.get_courses
        if response.code == 200
          render json: { status: "success", message: "Canvas API connection successful!", data: response.parsed_response }, status: :ok
        else
          render json: { status: "error", message: "Canvas API connection failed", details: response }, status: :bad_gateway
        end
      end
      
      def assignments
        response = @canvas_service.get_upcoming_assignments
        render json: response.parsed_response
      end
      
      def upcoming_assignments
        response = @canvas_service.get_upcoming_assignments
        
        if response.code == 200
          assignments = response.parsed_response.map do |assignment|
            assignment_data = assignment['assignment'] || {}
            # Extract necessary fields from each assignment
            {
              title: assignment['title'] || assignment['name'],
              start_date: assignment_data['unlock_at'],
              end_date: assignment['end_at'],
              deadline: assignment_data['due_at'],
              course_name: assignment['context_name'] || assignment['course_name'],
              priority: determine_priority(assignment_data['due_at'])
            }
          end
          
          render json: assignments
        else
          render json: { error: "Failed to fetch assignments", status: response.code }, status: :bad_gateway
        end
      end
      
      # def calendar_events
      #   start_date = params[:start_date] ? Date.parse(params[:start_date]) : Date.today
      #   end_date = params[:end_date] ? Date.parse(params[:end_date]) : (Date.today + 30)
        
      #   response = @canvas_service.get_calendar_events(start_date, end_date)
      #   render json: response.parsed_response
      # end
      
      private

      def determine_priority(assignment)
        # Simple logic to determine priority based on due date
        return 'unknown' unless assignment
        
        due_date = DateTime.parse(assignment)
        current_date = DateTime.now
        days_until_due = (due_date - current_date).to_i
        
        if days_until_due <= 1
          'high'
        elsif days_until_due <= 3
          'medium'
        else
          'low'
        end
      rescue
        'unknown' # In case date parsing fails
      end

      
      def set_canvas_service
        user_id = params[:user_id] || current_user.id # fallback to current_user if no param
        user = User.find_by(id: user_id)
      
        if user.nil? || user.canvas_api_token.blank?
          render json: { error: "Invalid user or missing Canvas API token" }, status: :unprocessable_entity
          return
        end
      
        api_token = user.canvas_api_token
        @canvas_service = CanvasApiService.new(api_token)
      end      
    end
  end
end