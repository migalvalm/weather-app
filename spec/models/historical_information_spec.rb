require "rails_helper"

RSpec.describe HistoricalInformation, type: :model do
  describe "validations" do
    describe "presence validations" do
      it "is valid with all required attributes" do
        historical_info = build(:historical_information)
        expect(historical_info).to be_valid
      end

      it "is invalid without start_date" do
        historical_info = build(:historical_information, start_date: nil)
        expect(historical_info).not_to be_valid
        expect(historical_info.errors[:start_date]).to include("can't be blank")
      end

      it "is invalid without end_date" do
        historical_info = build(:historical_information, end_date: nil)
        expect(historical_info).not_to be_valid
        expect(historical_info.errors[:end_date]).to include("can't be blank")
      end

      it "is invalid without data" do
        historical_info = build(:historical_information, data: nil)
        expect(historical_info).not_to be_valid
        expect(historical_info.errors[:data]).to include("can't be blank")
      end
    end

    describe "date validation" do
      it "is valid when end_date is after start_date" do
        historical_info = build(:historical_information, 
          start_date: Date.current, 
          end_date: Date.current + 1.day
        )
        expect(historical_info).to be_valid
      end

      it "is invalid when end_date is before start_date" do
        historical_info = build(:historical_information, 
          start_date: Date.current, 
          end_date: Date.current - 1.day
        )
        expect(historical_info).not_to be_valid
        expect(historical_info.errors[:end_date]).to include("must be after start date")
      end

      it "allows nil dates for validation but fails presence validation" do
        historical_info = build(:historical_information, 
          start_date: nil, 
          end_date: nil
        )
        expect(historical_info).not_to be_valid
        # Should fail presence validation, not date comparison validation
        expect(historical_info.errors[:start_date]).to include("can't be blank")
        expect(historical_info.errors[:end_date]).to include("can't be blank")
      end
    end
  end

  describe "database schema" do
    it "has the correct table structure" do
      expect(HistoricalInformation.new).to respond_to(:latitude)
      expect(HistoricalInformation.new).to respond_to(:longitude)
      expect(HistoricalInformation.new).to respond_to(:start_date)
      expect(HistoricalInformation.new).to respond_to(:end_date)
      expect(HistoricalInformation.new).to respond_to(:data)
      expect(HistoricalInformation.new).to respond_to(:created_at)
      expect(HistoricalInformation.new).to respond_to(:updated_at)
    end

    it "stores latitude and longitude as decimal values" do
      historical_info = create(:historical_information, 
        latitude: 40.7128, 
        longitude: -74.0060
      )
      expect(historical_info.latitude).to eq(BigDecimal("40.7128"))
      expect(historical_info.longitude).to eq(BigDecimal("-74.0060"))
    end

    it "stores data as jsonb" do
      test_data = { "sunrise" => "06:00", "sunset" => "18:00" }
      historical_info = create(:historical_information, data: test_data)
      expect(historical_info.data).to eq(test_data)
    end
  end

  describe "associations" do
    it "inherits from ApplicationRecord" do
      expect(HistoricalInformation < ApplicationRecord).to be true
    end
  end
end
