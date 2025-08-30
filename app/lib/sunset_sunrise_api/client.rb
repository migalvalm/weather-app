module SunsetSunriseApi
  module Client
    class << self
      def get_date_range(latitude:, longitude:, start_date:, end_date:)
        response = connection.get do |request|
          request.url ENDPOINT, {
            lat: latitude,
            lng: longitude,
            date_start: start_date,
            date_end: end_date
          }
        end

        GetDateRangeResponse.new(response).data
      end

      private

      ENDPOINT = "/json".freeze

      def connection
        @_connection ||= Faraday.new(url: base_url) do |builder|
          builder.request :json
          builder.response :json
          builder.response :logger, nil, {headers: false, bodies: true, errors: true} unless Rails.env.test?
          builder.adapter Faraday.default_adapter
        end
      end

      def base_url = Rails.env.production? ? Rails.configuration.sunset_sunrise_production_api : Rails.configuration.sunset_sunrise_dev_api
    end
  end
end