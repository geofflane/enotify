class CreateIncidents < ActiveRecord::Migration
  def self.up
    create_table :incidents do |t|
      t.integer  :enotify_mail_id
      t.integer  :address_id
      t.integer  :geo_location_id
      t.string   :report_number
      t.datetime :time
      t.string   :description
      t.string   :resolution

      t.timestamps
    end
  end

  def self.down
    drop_table :crime_reports
  end
end
