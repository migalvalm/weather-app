require "rails_helper"

RSpec.describe SunsetSunriseApi::Response do
  let(:response_mock) { double(body: { "test" => "data" }) }
  let(:response) { described_class.new(response_mock) }

  describe "initialization" do
    it "accepts a response object" do
      expect(response).to be_a(described_class)
    end

    it "stores the response object" do
      expect(response.response).to eq(response_mock)
    end
  end

  describe "#parsed_json" do
    it "returns the response body" do
      result = response.send(:parsed_json)
      expect(result).to eq({ "test" => "data" })
    end

    it "accesses the response body correctly" do
      expect(response_mock).to receive(:body).and_return({ "key" => "value" })
      
      result = response.send(:parsed_json)
      expect(result).to eq({ "key" => "value" })
    end

    it "handles different response body types" do
      # Test with array
      allow(response_mock).to receive(:body).and_return([1, 2, 3])
      result = response.send(:parsed_json)
      expect(result).to eq([1, 2, 3])

      # Test with string
      allow(response_mock).to receive(:body).and_return("test string")
      result = response.send(:parsed_json)
      expect(result).to eq("test string")

      # Test with nil
      allow(response_mock).to receive(:body).and_return(nil)
      result = response.send(:parsed_json)
      expect(result).to be_nil
    end
  end

  describe "inheritance" do
    it "inherits from Struct" do
      expect(described_class < Struct).to be true
    end

    it "has response as a member" do
      expect(response).to respond_to(:response)
    end
  end


  describe "edge cases" do
    it "handles response object with nil body" do
      nil_body_response = double(body: nil)
      nil_body_response_instance = described_class.new(nil_body_response)
      
      result = nil_body_response_instance.send(:parsed_json)
      expect(result).to be_nil
    end

    it "handles response object that doesn't respond to body" do
      invalid_response = double
      allow(invalid_response).to receive(:body).and_raise(NoMethodError.new("undefined method `body'"))
      invalid_response_instance = described_class.new(invalid_response)
      
      expect {
        invalid_response_instance.send(:parsed_json)
      }.to raise_error(NoMethodError)
    end

    it "handles complex nested response bodies" do
      complex_body = {
        "nested" => {
          "array" => [1, 2, 3],
          "string" => "test",
          "boolean" => true,
          "null" => nil
        },
        "simple" => "value"
      }
      
      complex_response = double(body: complex_body)
      complex_response_instance = described_class.new(complex_response)
      
      result = complex_response_instance.send(:parsed_json)
      expect(result).to eq(complex_body)
      expect(result["nested"]["array"]).to eq([1, 2, 3])
      expect(result["nested"]["string"]).to eq("test")
      expect(result["nested"]["boolean"]).to be true
      expect(result["nested"]["null"]).to be_nil
      expect(result["simple"]).to eq("value")
    end
  end

  describe "usage as base class" do
    it "can be inherited by other classes" do
      test_subclass = Class.new(described_class) do
        def custom_method
          parsed_json["test"]
        end
      end
      
      subclass_instance = test_subclass.new(response_mock)
      expect(subclass_instance.custom_method).to eq("data")
    end

    it "provides consistent interface for subclasses" do
      test_subclass = Class.new(described_class) do
        def get_data
          parsed_json
        end
      end
      
      subclass_instance = test_subclass.new(response_mock)
      expect(subclass_instance.get_data).to eq({ "test" => "data" })
    end
  end
end
