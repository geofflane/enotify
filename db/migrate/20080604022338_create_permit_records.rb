class CreatePermitRecords < ActiveRecord::Migration
  def self.up
    create_table :permit_records do |t|
      t.integer  :enotify_mail_id
      t.integer  :address_id
      t.integer  :geo_location_id
      t.string   :tax_key
      t.string   :record_number
      t.string   :description
      t.datetime :time
      
      t.timestamps
    end
  end

  def self.down
    drop_table :permit_records
  end
end
