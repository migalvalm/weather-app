FactoryBot.define do
  factory :historical_information do
    latitude { 40.7128 }
    longitude { -74.0060 }
    start_date { Date.current }
    end_date { Date.current + 1.day }
    data do
      [
        {
          "date" => "2024-01-01",
          "sunrise_time" => "07:00:00",
          "sunset_time" => "17:00:00",
          "golden_hour" => "16:00:00"
        },
        {
          "date" => "2024-01-02",
          "sunrise_time" => "07:01:00",
          "sunset_time" => "17:01:00",
          "golden_hour" => "16:01:00"
        }
      ]
    end

    trait :with_empty_data do
      data { [] }
    end

    trait :with_nil_data do
      data { nil }
    end

    trait :invalid_dates do
      start_date { Date.current }
      end_date { Date.current - 1.day }
    end

    trait :same_dates do
      start_date { Date.current }
      end_date { Date.current }
    end

    trait :new_york do
      latitude { 40.7128 }
      longitude { -74.0060 }
    end

    trait :london do
      latitude { 51.5074 }
      longitude { -0.1278 }
    end

    trait :tokyo do
      latitude { 35.6762 }
      longitude { 139.6503 }
    end
  end
end
