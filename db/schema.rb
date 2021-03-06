# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20130627182703) do

  create_table "card_in_decks", :force => true do |t|
    t.integer "card_id",     :null => false
    t.integer "deck_id",     :null => false
    t.integer "main_copies", :null => false
    t.integer "side_copies"
  end

  create_table "cards", :force => true do |t|
    t.string   "name",                          :null => false
    t.string   "mana_cost",                     :null => false
    t.string   "main_type",                     :null => false
    t.string   "sub_type"
    t.boolean  "foil",       :default => false, :null => false
    t.string   "rarity",                        :null => false
    t.integer  "count",                         :null => false
    t.string   "image_name",                    :null => false
    t.text     "text_box"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "cards_editions", :id => false, :force => true do |t|
    t.integer "card_id",    :null => false
    t.integer "edition_id", :null => false
  end

  create_table "decks", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "format",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "editions", :force => true do |t|
    t.string  "name",         :null => false
    t.string  "code_name",    :null => false
    t.string  "online_code"
    t.date    "release_date", :null => false
    t.integer "card_count",   :null => false
  end

end
