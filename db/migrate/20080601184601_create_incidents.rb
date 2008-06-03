class CreateIncidents < ActiveRecord::Migration
  def self.up
    create_table :incidents do |t|
      t.integer :enotify_mail_id
      t.string :report_number
      t.datetime :time
      t.string :description
      t.string :resolution
      t.string :address_street1
      t.string :address_street2
      t.string :address_city
      t.string :address_state, :limit => 2
      t.string :address_zip, :limit => 10
      t.string :geo_location_long
      t.string :geo_location_lat

      t.timestamps
    end
  end

  def self.down
    drop_table :crime_reports
  end
end
