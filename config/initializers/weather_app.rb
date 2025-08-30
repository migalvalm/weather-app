Rails.application.config.tap do |config|
  config.sunset_sunrise_production_api = ENV["SUNSET_SUNRISE_PRODUCTION_API_LINK"]
  config.sunset_sunrise_dev_api = ENV["SUNSET_SUNRISE_DEV_API_LINK"]
end