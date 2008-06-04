class CreateServiceRequests < ActiveRecord::Migration
  def self.up
    create_table :service_requests do |t|
      t.integer :enotify_mail_id
      t.string :tax_key
      t.string :record_number
      t.string :complaint
      t.datetime :time
      t.string :address_street
      t.string :address_city
      t.string :address_state, :limit => 2
      t.string :address_zip, :limit => 10
      t.string :geo_location_lat
      t.string :geo_location_long

      t.timestamps
    end
  end

  def self.down
    drop_table :service_requests
  end
end
