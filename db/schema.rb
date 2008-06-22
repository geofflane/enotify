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

ActiveRecord::Schema.define(:version => 20080622011156) do

  create_table "addresses", :force => true do |t|
    t.integer  "geo_location_id", :limit => 11
    t.string   "street"
    t.string   "city"
    t.string   "state",           :limit => 2
    t.string   "zip",             :limit => 5
    t.integer  "street_number",   :limit => 11
    t.string   "street_name"
    t.string   "full_zip",        :limit => 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "enotify_mails", :force => true do |t|
    t.string   "title"
    t.text     "original_text"
    t.text     "clean_text"
    t.boolean  "success"
    t.text     "parse_error"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "geo_locations", :force => true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "incidents", :force => true do |t|
    t.integer  "enotify_mail_id", :limit => 11
    t.integer  "address_id",      :limit => 11
    t.integer  "geo_location_id", :limit => 11
    t.string   "record_number",   :limit => 25
    t.datetime "incident_time"
    t.string   "description",     :limit => 500
    t.string   "resolution"
    t.string   "tax_key",         :limit => 50
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name",              :limit => 40
    t.string   "authorizable_type", :limit => 40
    t.integer  "authorizable_id",   :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "user_id",    :limit => 11
    t.integer  "role_id",    :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "state",                                   :default => "passive"
    t.datetime "deleted_at"
  end

end
