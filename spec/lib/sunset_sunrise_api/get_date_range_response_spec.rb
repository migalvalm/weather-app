require "rails_helper"

RSpec.describe SunsetSunriseApi::GetDateRangeResponse do
  let(:valid_response_body) do
    {
      "results" => [
        {
          "date" => "2024-01-01",
          "sunrise" => "07:00:00",
          "sunset" => "17:00:00",
          "golden_hour" => "16:00:00"
        },
        {
          "date" => "2024-01-02",
          "sunrise" => "07:01:00",
          "sunset" => "17:01:00",
          "golden_hour" => "16:01:00"
        }
      ]
    }
  end
  
  let(:response_mock) { double(body: valid_response_body) }
  let(:response) { described_class.new(response_mock) }

  describe "#data" do
    context "with valid response" do
      it "returns an array of date information" do
        result = response.data
        
        expect(result).to be_an(Array)
        expect(result.length).to eq(2)
      end

      it "transforms each result into the correct format" do
        result = response.data
        first_item = result.first
        
        expect(first_item[:date]).to eq("2024-01-01")
        expect(first_item[:sunrise_time]).to eq("07:00:00")
        expect(first_item[:sunset_time]).to eq("17:00:00")
        expect(first_item[:golden_hour]).to eq("16:00:00")
      end

      it "handles multiple results correctly" do
        result = response.data
        
        expect(result[0][:date]).to eq("2024-01-01")
        expect(result[1][:date]).to eq("2024-01-02")
      end

      it "preserves all required fields from the API response" do
        result = response.data
        first_item = result.first
        
        required_fields = [:date, :sunrise_time, :sunset_time, :golden_hour]
        required_fields.each do |field|
          expect(first_item.keys).to include(field)
          expect(first_item[field]).not_to be_nil
        end
      end
    end

    context "with empty results" do
      it "returns empty array when results is empty" do
        empty_response_body = { "results" => [] }
        empty_response_mock = double(body: empty_response_body)
        empty_response = described_class.new(empty_response_mock)
        
        result = empty_response.data
        expect(result).to eq([])
      end

      it "returns empty array when results is nil" do
        nil_response_body = { "results" => nil }
        nil_response_mock = double(body: nil_response_body)
        nil_response = described_class.new(nil_response_mock)
        
        result = nil_response.data
        expect(result).to eq([])
      end

      it "returns empty array when results key is missing" do
        missing_key_response_body = { "other_data" => "value" }
        missing_key_response_mock = double(body: missing_key_response_body)
        missing_key_response = described_class.new(missing_key_response_mock)
        
        result = missing_key_response.data
        expect(result).to eq([])
      end
    end

    context "with malformed results" do
      it "handles results with missing fields gracefully" do
        malformed_response_body = {
          "results" => [
            {
              "date" => "2024-01-01",
              "sunrise" => "07:00:00"
              # Missing sunset and golden_hour
            }
          ]
        }
        malformed_response_mock = double(body: malformed_response_body)
        malformed_response = described_class.new(malformed_response_mock)
        
        result = malformed_response.data
        expect(result.length).to eq(1)
        expect(result.first[:date]).to eq("2024-01-01")
        expect(result.first[:sunrise_time]).to eq("07:00:00")
        expect(result.first[:sunset_time]).to be_nil
        expect(result.first[:golden_hour]).to be_nil
      end

      it "handles results with extra fields" do
        extra_fields_response_body = {
          "results" => [
            {
              "date" => "2024-01-01",
              "sunrise" => "07:00:00",
              "sunset" => "17:00:00",
              "golden_hour" => "16:00:00",
              "extra_field" => "should_be_ignored"
            }
          ]
        }
        extra_fields_response_mock = double(body: extra_fields_response_body)
        extra_fields_response = described_class.new(extra_fields_response_mock)
        
        result = extra_fields_response.data
        expect(result.length).to eq(1)
        expect(result.first.keys).not_to include("extra_field")
      end
    end

    context "field mapping" do
      it "maps sunrise to sunrise_time" do
        result = response.data
        expect(result.first[:sunrise_time]).to eq("07:00:00")
      end

      it "maps sunset to sunset_time" do
        result = response.data
        expect(result.first[:sunset_time]).to eq("17:00:00")
      end

      it "preserves date field as is" do
        result = response.data
        expect(result.first[:date]).to eq("2024-01-01")
      end

      it "preserves golden_hour field as is" do
        result = response.data
        expect(result.first[:golden_hour]).to eq("16:00:00")
      end
    end
  end

  describe "inheritance" do
    it "inherits from Response" do
      expect(described_class < SunsetSunriseApi::Response).to be true
    end

    it "has access to parsed_json method" do
      expect(response).to respond_to(:parsed_json, true)
    end
  end

  describe "private methods" do
    describe "#date_params" do
      it "transforms a single result correctly" do
        single_result = {
          "date" => "2024-01-01",
          "sunrise" => "07:00:00",
          "sunset" => "17:00:00",
          "golden_hour" => "16:00:00"
        }
        
        result = response.send(:date_params, single_result)
        
        expect(result[:date]).to eq("2024-01-01")
        expect(result[:sunrise_time]).to eq("07:00:00")
        expect(result[:sunset_time]).to eq("17:00:00")
        expect(result[:golden_hour]).to eq("16:00:00")
      end

      it "handles missing fields in result" do
        incomplete_result = {
          "date" => "2024-01-01",
          "sunrise" => "07:00:00"
          # Missing sunset and golden_hour
        }
        
        result = response.send(:date_params, incomplete_result)
        
        expect(result[:date]).to eq("2024-01-01")
        expect(result[:sunrise_time]).to eq("07:00:00")
        expect(result[:sunset_time]).to be_nil
        expect(result[:golden_hour]).to be_nil
      end

      it "ignores extra fields in result" do
        extra_fields_result = {
          "date" => "2024-01-01",
          "sunrise" => "07:00:00",
          "sunset" => "17:00:00",
          "golden_hour" => "16:00:00",
          "extra_field" => "should_be_ignored"
        }
        
        result = response.send(:date_params, extra_fields_result)
        
        expect(result.keys).not_to include("extra_field")
        expect(result.keys.length).to eq(4)
      end
    end
  end

  describe "edge cases" do
    it "handles empty result objects" do
      empty_result_response_body = {
        "results" => [{}]
      }
      empty_result_response_mock = double(body: empty_result_response_body)
      empty_result_response = described_class.new(empty_result_response_mock)
      
      result = empty_result_response.data
      expect(result.length).to eq(1)
      expect(result.first["date"]).to be_nil
      expect(result.first["sunrise_time"]).to be_nil
      expect(result.first["sunset_time"]).to be_nil
      expect(result.first["golden_hour"]).to be_nil
    end

    it "handles non-string values" do
      non_string_response_body = {
        "results" => [
          {
            "date" => 20240101,
            "sunrise" => 70000,
            "sunset" => 170000,
            "golden_hour" => 160000
          }
        ]
      }
      non_string_response_mock = double(body: non_string_response_body)
      non_string_response = described_class.new(non_string_response_mock)
      
      result = non_string_response.data
              expect(result.first[:date]).to eq(20240101)
        expect(result.first[:sunrise_time]).to eq(70000)
        expect(result.first[:sunset_time]).to eq(170000)
        expect(result.first[:golden_hour]).to eq(160000)
    end

    it "handles very large datasets" do
      large_dataset = { "results" => [] }
      1000.times do |i|
        large_dataset["results"] << {
          "date" => "2024-01-#{i + 1}",
          "sunrise" => "07:00:00",
          "sunset" => "17:00:00",
          "golden_hour" => "16:00:00"
        }
      end
      
      large_dataset_response_mock = double(body: large_dataset)
      large_dataset_response = described_class.new(large_dataset_response_mock)
      
      result = large_dataset_response.data
      expect(result.length).to eq(1000)
              expect(result.first[:date]).to eq("2024-01-1")
        expect(result.last[:date]).to eq("2024-01-1000")
    end
  end
end
