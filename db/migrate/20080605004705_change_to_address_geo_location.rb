class ChangeToAddressGeoLocation < ActiveRecord::Migration
  def self.up
    add_column :incidents, :address_id, :integer
    add_column :permit_records, :address_id, :integer
    add_column :service_requests, :address_id, :integer
    
    add_column :incidents, :geo_location_id, :integer
    add_column :permit_records, :geo_location_id, :integer
    add_column :service_requests, :geo_location_id, :integer
    
    remove_column :incidents, :address_street
    remove_column :incidents, :address_city
    remove_column :incidents, :address_state
    remove_column :incidents, :address_zip
    remove_column :incidents, :geo_location_lat
    remove_column :incidents, :geo_location_long
    
    remove_column :permit_records, :address_street
    remove_column :permit_records, :address_city
    remove_column :permit_records, :address_state
    remove_column :permit_records, :address_zip
    remove_column :permit_records, :geo_location_lat
    remove_column :permit_records, :geo_location_long
    
    remove_column :service_requests, :address_street
    remove_column :service_requests, :address_city
    remove_column :service_requests, :address_state
    remove_column :service_requests, :address_zip
    remove_column :service_requests, :geo_location_lat
    remove_column :service_requests, :geo_location_long
  end

  def self.down
    remove_column :incidents, :address_id
    remove_column :permit_records, :address_id
    remove_column :service_requests, :address_id
    
    remove_column :incidents, :geo_location_id
    remove_column :permit_records, :geo_location_id
    remove_column :service_requests, :geo_location_id
    
    add_column :incidents, :address_street, :string
    add_column :incidents, :address_city, :string
    add_column :incidents, :address_state, :string, :limit => 2
    add_column :incidents, :address_zip, :string, :limit => 10
    add_column :incidents, :geo_location_lat, :string
    add_column :incidents, :geo_location_long, :string
    
    add_column :permit_records, :address_street, :string
    add_column :permit_records, :address_city, :string
    add_column :permit_records, :address_state, :string, :limit => 2
    add_column :permit_records, :address_zip, :string, :limit => 10
    add_column :permit_records, :geo_location_lat, :string
    add_column :permit_records, :geo_location_long, :string
    
    add_column :service_requests, :address_street, :string
    add_column :service_requests, :address_city, :string
    add_column :service_requests, :address_state, :string, :limit => 2
    add_column :service_requests, :address_zip, :string, :limit => 10
    add_column :service_requests, :geo_location_lat, :string
    add_column :service_requests, :geo_location_long, :string
  end
end
