Geocoder.configure(
  lookup: [:location_iq, :nominatim],
  timeout: 5,
  cache: Rails.cache,
  cache_prefix: 'geocoder:'
)