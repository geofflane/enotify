class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.integer :geo_location_id
      t.string  :street
      t.string  :city
      t.string  :state, :limit => 2
      t.string  :zip, :limit => 5
      t.integer :street_number
      t.string  :street_name
      t.string  :full_zip, :limit => 10
      
      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end
