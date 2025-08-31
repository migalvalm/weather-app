# == Schema Information
#
# Table name: historical_informations
#
#  id         :integer          not null, primary key
#  latitude   :decimal(10, 7)
#  longitude  :decimal(10, 7)
#  start_date :date
#  end_date   :date
#  data       :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_historical_informations_on_end_date                (end_date)
#  index_historical_informations_on_latitude_and_longitude  (latitude,longitude)
#  index_historical_informations_on_start_date              (start_date)
#

class HistoricalInformation < ApplicationRecord
  validates :latitude, presence: true, numericality: {
    greater_than_or_equal_to: -90,
    less_than_or_equal_to: 90
  }
  validates :longitude, presence: true, numericality: {
    greater_than_or_equal_to: -180,
    less_than_or_equal_to: 180
  }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :data, presence: true
  
  validate :end_date_after_start_date
  
  private
  
  def end_date_after_start_date
    return if start_date.nil? || end_date.nil?
    errors.add(:end_date, 'must be after start date') if end_date <= start_date
  end
end
