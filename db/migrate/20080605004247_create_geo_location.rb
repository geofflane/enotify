class CreateGeoLocation < ActiveRecord::Migration
  def self.up
    create_table :geo_locations do |t|
      t.string :lat
      t.string :long
      
      t.timestamps
    end
  end

  def self.down
    drop_table :geo_locations
  end
end
