class AdjustIncidentColumnSizes < ActiveRecord::Migration
  def self.up
     change_column(:incidents, :description, :string, :limit => 500)
     change_column(:incidents, :record_number, :string, :limit => 25)
     change_column(:incidents, :tax_key, :string, :limit => 25)
     change_column(:incidents, :tax_key, :string, :limit => 50)
  end

  def self.down
    change_column(:incidents, :description, :string, :limit => 255)
    change_column(:incidents, :record_number, :string, :limit => 255)
    change_column(:incidents, :tax_key, :string, :limit => 255)
    change_column(:incidents, :tax_key, :string, :limit => 255)
  end
end
