class HistoricalInformationsController < ApplicationController
  before_action :set_historical_information, only: :show

  def index
    @historical_information = HistoricalInformation.new(
      latitude: @coordinates[0],
      longitude: @coordinates[1],
      start_date: Time.current - 1.day,
      end_date: Time.current
    )

    respond_to do |format|
      format.html
    end
  end

  
  def create
    @historical_information = FetchDateRangeSunsetSunrise.new.call(
      latitude: historical_information_params["latitude"], 
      longitude: historical_information_params["longitude"], 
      start_date: historical_information_params["start_date"], 
      end_date: historical_information_params["end_date"]
    )

    if @historical_information.data.present?
      redirect_to historical_information_path(@historical_information)
    else
      render :index
    end
  end

  def show
  end

  private

  def set_historical_information
    @historical_information ||= HistoricalInformation.find(params[:id])
  end

  def historical_information_params
    params.permit(
      historical_information: [
        :latitude,
        :longitude,
        :start_date,
        :end_date
      ]
    )[:historical_information]
  end
end