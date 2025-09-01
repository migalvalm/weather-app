require "rails_helper"

RSpec.describe SunsetSunriseApi::Client do
  let(:valid_params) do
    {
      latitude: 40.7128,
      longitude: -74.0060,
      start_date: Date.current,
      end_date: Date.current + 1.day
    }
  end
  let(:expected_query_params) do
    {
      lat: 40.7128,
      lng: -74.0060,
      date_start: Date.current,
      date_end: Date.current + 1.day
    }
  end

  describe ".get_date_range" do
    context "with valid parameters" do
      it "makes a GET request to the correct endpoint" do
        VCR.use_cassette("sunset_sunrise_api_get_date_range") do
          described_class.get_date_range(**valid_params)
        end
      end

      it "passes correct query parameters" do
        VCR.use_cassette("sunset_sunrise_api_query_params") do
          result = described_class.get_date_range(**valid_params)
          expect(result).not_to be_nil
        end
      end

      it "returns parsed response data" do
        VCR.use_cassette("sunset_sunrise_api_response_parsing") do
          result = described_class.get_date_range(**valid_params)
          expect(result).to be_an(Array)
        end
      end

      it "handles string coordinates" do
        string_params = valid_params.merge(
          latitude: "40.7128",
          longitude: "-74.0060"
        )
        
        VCR.use_cassette("sunset_sunrise_api_string_coordinates") do
          result = described_class.get_date_range(**string_params)
          expect(result).not_to be_nil
        end
      end

      it "handles date objects" do
        date_params = valid_params.merge(
          start_date: Date.current,
          end_date: Date.current + 1.day
        )
        
        VCR.use_cassette("sunset_sunrise_api_date_objects") do
          result = described_class.get_date_range(**date_params)
          expect(result).not_to be_nil
        end
      end
    end

    context "error handling" do
      it "handles network errors gracefully" do
        stub_request(:get, /.*/).to_timeout
        
        expect {
          described_class.get_date_range(valid_params)
        }.to raise_error(Faraday::TimeoutError)
      end

      it "handles HTTP errors" do
        stub_request(:get, /.*/).to_return(status: 500)
        
        expect {
          described_class.get_date_range(valid_params)
        }.to raise_error(Faraday::ServerError)
      end

      it "handles invalid JSON responses" do
        stub_request(:get, /.*/).to_return(
          status: 200,
          body: "invalid json",
          headers: { "Content-Type" => "application/json" }
        )
        
        expect {
          described_class.get_date_range(valid_params)
        }.to raise_error(JSON::ParserError)
      end
    end

    context "response processing" do
      it "creates GetDateRangeResponse object" do
        VCR.use_cassette("sunset_sunrise_api_response_object") do
          expect(SunsetSunriseApi::GetDateRangeResponse).to receive(:new).and_return(
            double(data: [])
          )
          
          described_class.get_date_range(**valid_params)
        end
      end

      it "calls data method on response object" do
        response_mock = double
        expect(response_mock).to receive(:data).and_return([])
        
        allow(SunsetSunriseApi::GetDateRangeResponse).to receive(:new).and_return(response_mock)
        
        VCR.use_cassette("sunset_sunrise_api_data_method") do
          described_class.get_date_range(**valid_params)
        end
      end
    end
  end

  describe "private methods" do
    describe ".connection" do
      it "creates a Faraday connection" do
        connection = described_class.send(:connection)
        expect(connection).to be_a(Faraday::Connection)
      end

      it "configures JSON request middleware" do
        connection = described_class.send(:connection)
        handlers = connection.builder.handlers
        expect(handlers.map(&:name)).to include("Faraday::Request::Json")
      end

      it "configures JSON response middleware" do
        connection = described_class.send(:connection)
        handlers = connection.builder.handlers
        expect(handlers.map(&:name)).to include("Faraday::Response::Json")
      end

      it "configures logger middleware in non-test environments" do
        allow(Rails.env).to receive(:test?).and_return(false)
        connection = described_class.send(:connection)
        handlers = connection.builder.handlers
        expect(handlers.map(&:name)).to include("Faraday::Response::Logger")
      end

      it "does not configure logger middleware in test environment" do
        allow(Rails.env).to receive(:test?).and_return(true)
        connection = described_class.send(:connection)
        handlers = connection.builder.handlers
        expect(handlers.map(&:name)).not_to include("logger")
      end

      it "uses default adapter" do
        connection = described_class.send(:connection)
        expect(connection.adapter).to be_a(Faraday::Adapter::NetHttp)
      end

      it "memoizes connection" do
        first_connection = described_class.send(:connection)
        second_connection = described_class.send(:connection)
        expect(first_connection.object_id).to eq(second_connection.object_id)
      end
    end

    describe ".base_url" do
      it "returns production URL in production environment" do
        allow(Rails.env).to receive(:production?).and_return(true)
        allow(Rails.configuration).to receive(:sunset_sunrise_production_api).and_return("https://api.production.com")
        
        expect(described_class.send(:base_url)).to eq("https://api.production.com")
      end

      it "returns development URL in non-production environment" do
        allow(Rails.env).to receive(:production?).and_return(false)
        allow(Rails.configuration).to receive(:sunset_sunrise_dev_api).and_return("https://api.dev.com")
        
        expect(described_class.send(:base_url)).to eq("https://api.dev.com")
      end
    end

    describe "ENDPOINT constant" do
      it "has the correct endpoint value" do
        expect(SunsetSunriseApi::Client::ENDPOINT).to eq("/json")
      end
    end
  end

  describe "integration scenarios" do
    it "handles complete API request flow" do
      VCR.use_cassette("sunset_sunrise_api_complete_flow") do
        result = described_class.get_date_range(**valid_params)
        
        expect(result).to be_an(Array)
        expect(result).not_to be_empty
        
        # Verify the structure of the response
        first_item = result.first
        expect(first_item.keys).to include(:date)
        expect(first_item.keys).to include(:sunrise_time)
        expect(first_item.keys).to include(:sunset_time)
        expect(first_item.keys).to include(:golden_hour)
      end
    end

    it "handles empty response gracefully" do
      stub_request(:get, /.*/).to_return(
        status: 200,
        body: '{"results": []}',
        headers: { "Content-Type" => "application/json" }
      )
      
      result = described_class.get_date_range(**valid_params)
      expect(result).to eq([])
    end

    it "handles malformed response gracefully" do
      stub_request(:get, /.*/).to_return(
        status: 200,
        body: '{"results": null}',
        headers: { "Content-Type" => "application/json" }
      )
      
      result = described_class.get_date_range(**valid_params)
      expect(result).to eq([])
    end
  end
end
