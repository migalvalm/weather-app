module SunsetSunriseApi
  class Response < Struct.new(:response)
    protected

    def parsed_json
      response.body
    end
  end
end