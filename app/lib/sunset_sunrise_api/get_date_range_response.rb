module SunsetSunriseApi
  class GetDateRangeResponse < Response

    def data
      dates = []
      return dates if parsed_json["results"].nil?

      parsed_json["results"].each do |result|
        dates.push(date_params(result))
      end

      dates
    end

    private

    def date_params(result)
      {
        date: result["date"],
        sunrise_time: result["sunrise"],
        sunset_time: result["sunset"],
        golden_hour: result["golden_hour"]
      }
    end
  end
end