# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080601184601) do

  create_table "enotify_mails", :force => true do |t|
    t.string   "title"
    t.text     "full_text"
    t.boolean  "success"
    t.text     "parse_error"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "incidents", :force => true do |t|
    t.integer  "enotify_mail_id"
    t.string   "report_number"
    t.datetime "time"
    t.string   "description"
    t.string   "resolution"
    t.string   "address_street1"
    t.string   "address_street2"
    t.string   "address_city"
    t.string   "address_state",     :limit => 2
    t.string   "address_zip",       :limit => 10
    t.string   "geo_location_long"
    t.string   "geo_location_lat"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
