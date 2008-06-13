class CreateEnotifyMails < ActiveRecord::Migration
  def self.up
    create_table :enotify_mails do |t|
      t.string   :title
      t.text     :original_text
      t.text     :clean_text
      t.boolean  :success
      t.text     :parse_error

      t.timestamps
    end
  end

  def self.down
    drop_table :enotify_mails
  end
end
