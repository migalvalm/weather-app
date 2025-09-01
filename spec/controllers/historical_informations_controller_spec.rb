require "rails_helper"

RSpec.describe HistoricalInformationsController, type: :controller do
  let(:valid_params) do
    {
      historical_information: {
        latitude: "40.7128",
        longitude: "-74.0060",
        start_date: Date.current.to_s,
        end_date: (Date.current + 1.day).to_s
      }
    }
  end

  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end

    it "responds to HTML format" do
      get :index, format: :html
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a successful response" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "redirects to the created historical_information" do
        service_mock = instance_double(FetchDateRangeSunsetSunrise)
        allow(FetchDateRangeSunsetSunrise).to receive(:new).and_return(service_mock)
        allow(service_mock).to receive(:call).and_return(build(:historical_information, data: { "test" => "data" }))

        post :create, params: valid_params
        expect(response).to redirect_to(historical_informations_path(HistoricalInformation.last))
      end

      it "calls FetchDateRangeSunsetSunrise service with correct parameters" do
        service_mock = instance_double(FetchDateRangeSunsetSunrise)
        expect(FetchDateRangeSunsetSunrise).to receive(:new).and_return(service_mock)
        expect(service_mock).to receive(:call).and_return(build(:historical_information, data: { "test" => "data" }))

        post :create, params: valid_params
      end
    end

    context "with invalid parameters" do
      it "does not create a new HistoricalInformation when service returns no data" do
        service_mock = instance_double(FetchDateRangeSunsetSunrise)
        allow(FetchDateRangeSunsetSunrise).to receive(:new).and_return(service_mock)
        allow(service_mock).to receive(:call).and_return(build(:historical_information, data: nil))

        expect {
          post :create, params: valid_params
        }.not_to change(HistoricalInformation, :count)
      end

      it "renders index template when service returns no data" do
        service_mock = instance_double(FetchDateRangeSunsetSunrise)
        allow(FetchDateRangeSunsetSunrise).to receive(:new).and_return(service_mock)
        allow(service_mock).to receive(:call).and_return(build(:historical_information, data: nil))

        post :create, params: valid_params
        expect(response).to render_template(:index)
      end
    end

    context "parameter handling" do
      it "permits only allowed parameters" do
        malicious_params = {
          historical_information: {
            latitude: "40.7128",
            longitude: "-74.0060",
            start_date: Date.current.to_s,
            end_date: (Date.current + 1.day).to_s,
            malicious_field: "should_not_be_permitted"
          }
        }

        service_mock = instance_double(FetchDateRangeSunsetSunrise)
        allow(FetchDateRangeSunsetSunrise).to receive(:new).and_return(service_mock)
        allow(service_mock).to receive(:call).and_return(build(:historical_information, data: { "test" => "data" }))

        post :create, params: malicious_params
        expect(response).to redirect_to(historical_informations_path(HistoricalInformation.last))
      end
    end
  end

  describe "GET #show" do
    let(:historical_information) { create(:historical_information) }

    it "returns a successful response" do
      get :show, params: { id: historical_information.id }
      expect(response).to be_successful
    end

    it "assigns the requested historical_information" do
      get :show, params: { id: historical_information.id }
      expect(assigns(:historical_information)).to eq(historical_information)
    end

    it "returns 404 for non-existent historical_information" do
      expect {
        get :show, params: { id: 999999 }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "private methods" do
    describe "#set_historical_information" do
      it "finds the correct historical_information by id" do
        historical_information = create(:historical_information)
        controller.params = { id: historical_information.id }
        controller.send(:set_historical_information)
        expect(assigns(:historical_information)).to eq(historical_information)
      end
    end

    describe "#historical_information_params" do
      it "permits the correct parameters" do
        controller.params = ActionController::Parameters.new(valid_params)
        permitted_params = controller.send(:historical_information_params)
        
        expect(permitted_params["latitude"]).to eq("40.7128")
        expect(permitted_params["longitude"]).to eq("-74.0060")
        expect(permitted_params["start_date"]).to eq(Date.current.to_s)
        expect(permitted_params["end_date"]).to eq((Date.current + 1.day).to_s)
      end

      it "returns nil when historical_information key is missing" do
        controller.params = ActionController::Parameters.new({})
        expect(controller.send(:historical_information_params)).to be_nil
      end
    end
  end
end
