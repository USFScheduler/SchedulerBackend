# app/services/canvas_api_service.rb
require 'httparty'

class CanvasApiService
  include HTTParty
  
  def initialize(api_token, canvas_url = nil)
    @api_token = api_token
    @canvas_url = canvas_url || "https://usflearn.instructure.com/api/v1"
    self.class.base_uri @canvas_url
    self.class.headers 'Authorization' => "Bearer #{@api_token}"
  end
  
  def get_courses
    self.class.get("/courses")
  end
  
  def get_assignments(course_id)
    self.class.get("/courses/#{course_id}/assignments")
  end
  
  def get_assignment_submissions(course_id, assignment_id)
    self.class.get("/courses/#{course_id}/assignments/#{assignment_id}/submissions")
  end
  
  def get_upcoming_assignments
    # Get assignments due in the next two weeks
    two_weeks_from_now = (Date.today + 14).to_time.iso8601
    self.class.get("/users/self/upcoming_events?type=assignment&end_date=#{two_weeks_from_now}")
  end
  
  def get_calendar_events(start_date, end_date)
    # Format dates as ISO8601 strings
    start_date_iso = start_date.to_time.iso8601
    end_date_iso = end_date.to_time.iso8601
    
    self.class.get("/calendar_events?start_date=#{start_date_iso}&end_date=#{end_date_iso}&context_codes[]=user_self")
  end
end