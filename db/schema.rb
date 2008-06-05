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

ActiveRecord::Schema.define(:version => 20080605004705) do

  create_table "addresses", :force => true do |t|
    t.integer  "geo_location_id"
    t.string   "street"
    t.string   "city"
    t.string   "state",           :limit => 2
    t.string   "zip",             :limit => 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "enotify_mails", :force => true do |t|
    t.string   "title"
    t.text     "full_text"
    t.boolean  "success"
    t.text     "parse_error"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "geo_locations", :force => true do |t|
    t.string   "lat"
    t.string   "long"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "incidents", :force => true do |t|
    t.integer  "enotify_mail_id"
    t.string   "report_number"
    t.datetime "time"
    t.string   "description"
    t.string   "resolution"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "address_id"
    t.integer  "geo_location_id"
  end

  create_table "permit_records", :force => true do |t|
    t.integer  "enotify_mail_id"
    t.string   "tax_key"
    t.string   "record_number"
    t.string   "description"
    t.datetime "time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "address_id"
    t.integer  "geo_location_id"
  end

  create_table "service_requests", :force => true do |t|
    t.integer  "enotify_mail_id"
    t.string   "tax_key"
    t.string   "record_number"
    t.string   "complaint"
    t.datetime "time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "address_id"
    t.integer  "geo_location_id"
  end

end
