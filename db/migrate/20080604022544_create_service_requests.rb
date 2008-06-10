class CreateServiceRequests < ActiveRecord::Migration
  def self.up
    create_table :service_requests do |t|
      t.integer  :enotify_mail_id
      t.integer  :address_id
      t.integer  :geo_location_id
      t.string   :tax_key
      t.string   :record_number
      t.string   :complaint
      t.datetime :time

      t.timestamps
    end
  end

  def self.down
    drop_table :service_requests
  end
end
