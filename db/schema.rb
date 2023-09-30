# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_09_22_140039) do

  create_table "bills", force: :cascade do |t|
    t.string "customer_email"
    t.decimal "total_price"
    t.decimal "total_tax_payable"
    t.decimal "net_price"
    t.decimal "rounded_down_value"
    t.decimal "balance_payable_to_customer"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "amount_paid"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "denominations", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "items", force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "bill_id", null: false
    t.integer "quantity"
    t.decimal "item_total"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["bill_id"], name: "index_items_on_bill_id"
    t.index ["product_id"], name: "index_items_on_product_id"
  end

  create_table "line_items", force: :cascade do |t|
    t.string "product_name"
    t.integer "product_id"
    t.integer "quantity"
    t.decimal "unit_price"
    t.decimal "purchased_price"
    t.decimal "tax"
    t.decimal "tax_pay"
    t.decimal "total"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.decimal "price"
    t.decimal "tax_percentage"
    t.decimal "tax_pay"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "items", "bills"
  add_foreign_key "items", "products"
end
