# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120325111023) do

  create_table "formulas", :force => true do |t|
    t.string   "text"
    t.string   "filename"
    t.string   "color"
    t.integer  "size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "depth"
  end

  add_index "formulas", ["filename"], :name => "filename"

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.text     "content"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "problems", :force => true do |t|
    t.string   "name"
    t.text     "statement"
    t.text     "solution"
    t.string   "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "scoring"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                       :null => false
    t.string   "crypted_password"
    t.string   "salt"
    t.integer  "person_id",                    :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "activation_state"
    t.string   "activation_token"
    t.datetime "activation_token_expires_at"
    t.integer  "roles_mask"
  end

  add_index "users", ["activation_token"], :name => "index_users_on_activation_token"
  add_index "users", ["remember_me_token"], :name => "index_users_on_remember_me_token"

end
