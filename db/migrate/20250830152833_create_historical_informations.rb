class CreateHistoricalInformations < ActiveRecord::Migration[8.0]
  def change
    create_table :historical_informations do |t|
      t.decimal :latitude, precision: 10, scale: 7
      t.decimal :longitude, precision: 10, scale: 7
      t.date :start_date
      t.date :end_date
      t.jsonb :data

      t.timestamps
    end
    
    add_index :historical_informations, [:latitude, :longitude]
    add_index :historical_informations, :start_date
    add_index :historical_informations, :end_date
  end
end
