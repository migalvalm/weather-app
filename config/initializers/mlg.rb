Rails.application.config.tap do |config|
  config.next_mcu_film_production_api = ENV["NEXT_MCU_FILM_PRODUCTION_API_LINK"]
  config.next_mcu_film_dev_api = ENV["NEXT_MCU_FILM_DEV_API_LINK"]
end