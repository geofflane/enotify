class RenameTimeColumn < ActiveRecord::Migration
  def self.up
    rename_column :incidents, :time, :incident_time
  end

  def self.down
    rename_column :incidents, :incident_time, :time
  end
end
