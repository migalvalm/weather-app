class HistoricalInformationsController < ApplicationController
  before_action :set_historical_information

  def index
    @historical_information.latitude = @coordinates[0]
    @historical_information.longitude = @coordinates[1]
    @historical_information.start_date ||= Time.current.beginning_of_year
    @historical_information.end_date ||= Time.current
    
    respond_to do |format|
      format.html
    end
  end

  def new
    
  end
  
  def create
    @historical_information = FetchDateRangeSunsetSunrise.new.call(
      latitude: historical_information_params["latitude"], 
      longitude: historical_information_params["longitude"], 
      start_date: historical_information_params["start_date"], 
      end_date: historical_information_params["end_date"]
    )

    respond_to do |format|
      format.turbo_stream
    end
  end

  def show
  end

  private

  def set_historical_information
    @historical_information = HistoricalInformation.new
  end

  def historical_information_params
    params.permit(:latitude, :longitude, :start_date, :end_date)
  end
end