class CreatePermitRecords < ActiveRecord::Migration
  def self.up
    create_table :permit_records do |t|
      t.integer :enotify_mail_id
      t.string :tax_key
      t.string :record_number
      t.string :description
      t.datetime :time
      t.string :address_street
      t.string :address_city
      t.string :address_state, :limit => 2
      t.string :address_zip, :limit => 10
      t.string :geo_location_long
      t.string :geo_location_lat
      
      t.timestamps
    end
  end

  def self.down
    drop_table :permit_records
  end
end
