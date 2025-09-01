class FetchDateRangeSunsetSunrise
  def call(latitude:, longitude:, start_date:, end_date:)
    cached_historical_information = find_cached_data(latitude, longitude, start_date, end_date)
    return cached_historical_information if cached_historical_information&.data

    api_data = SunsetSunriseApi::Client.get_date_range(
      latitude: latitude,
      longitude: longitude,
      start_date: start_date,
      end_date: end_date
    )
    
    store_data(latitude, longitude, start_date, end_date, api_data)
  end

  private

  def find_cached_data(latitude, longitude, start_date, end_date)
    HistoricalInformation.find_by(
      latitude: latitude,
      longitude: longitude,
      start_date: start_date,
      end_date: end_date
    )
  end

  def store_data(latitude, longitude, start_date, end_date, data)
    HistoricalInformation.create!(
      latitude: latitude,
      longitude: longitude,
      start_date: start_date,
      end_date: end_date,
      data: data
    )
  end
end