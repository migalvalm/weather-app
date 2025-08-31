class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :set_coordinates

  private 

  def user_latitude
    @coordinates[0]
  end

  def user_longitude
    @coordinates[1]
  end

  def set_coordinates
    @coordinates ||= Rails.cache.fetch("user_location/#{request.ip}", expires_in: 1.hour) do
      request.location.coordinates
    end 
  end
end
