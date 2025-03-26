class CanvasRedirectController < ApplicationController
  def redirect_to_canvas
    canvas_url = "#{ENV['CANVAS_URL']}/login/oauth2/auth" \
    "?client_id=#{ENV['CANVAS_CLIENT_ID']}" \
    "&response_type=code" \
    "&redirect_uri=#{CGI.escape(ENV['CANVAS_REDIRECT_URI'])}" \
    "&scope=url:GET|/api/v1/courses"

    redirect_to canvas_url
  end
end
