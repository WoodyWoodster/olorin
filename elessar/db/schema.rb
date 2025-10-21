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

ActiveRecord::Schema[8.0].define(version: 2025_10_21_011140) do
  create_table "addresses", force: :cascade do |t|
    t.integer "organization_id", null: false
    t.string "addressable_type", null: false
    t.integer "addressable_id", null: false
    t.string "address_type", null: false
    t.string "street", null: false
    t.string "street2"
    t.string "city", null: false
    t.string "state"
    t.string "postal_code"
    t.string "country", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["addressable_type", "addressable_id", "address_type"], name: "index_addresses_on_addressable_and_type"
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable"
    t.index ["organization_id", "addressable_type", "addressable_id"], name: "index_addresses_on_org_and_addressable"
    t.index ["organization_id"], name: "index_addresses_on_organization_id"
  end

  create_table "companies", force: :cascade do |t|
    t.integer "organization_id", null: false
    t.string "name", null: false
    t.string "company_type", null: false
    t.string "tax_id"
    t.string "website"
    t.string "phone"
    t.string "email"
    t.boolean "is_active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "company_type"], name: "index_companies_on_organization_id_and_company_type"
    t.index ["organization_id", "is_active"], name: "index_companies_on_organization_id_and_is_active"
    t.index ["organization_id", "name"], name: "index_companies_on_organization_id_and_name"
    t.index ["organization_id"], name: "index_companies_on_organization_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.integer "organization_id", null: false
    t.integer "company_id"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.string "mobile"
    t.string "role"
    t.boolean "is_primary", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id", "is_primary"], name: "index_contacts_on_company_id_and_is_primary"
    t.index ["company_id"], name: "index_contacts_on_company_id"
    t.index ["organization_id", "email"], name: "index_contacts_on_organization_id_and_email"
    t.index ["organization_id"], name: "index_contacts_on_organization_id"
  end

  create_table "jwt_denylists", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_denylists_on_jti", unique: true
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.string "subdomain", null: false
    t.json "settings", default: {}
    t.boolean "is_active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_organizations_on_name"
    t.index ["subdomain"], name: "index_organizations_on_subdomain", unique: true
  end

  create_table "products", force: :cascade do |t|
    t.integer "organization_id", null: false
    t.string "sku", null: false
    t.string "name", null: false
    t.text "description"
    t.string "product_type", null: false
    t.string "unit_of_measure", null: false
    t.decimal "cost", precision: 10, scale: 2
    t.decimal "price", precision: 10, scale: 2
    t.boolean "is_manufactured", default: false, null: false
    t.boolean "is_active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "is_active"], name: "index_products_on_organization_id_and_is_active"
    t.index ["organization_id", "name"], name: "index_products_on_organization_id_and_name"
    t.index ["organization_id", "sku"], name: "index_products_on_organization_id_and_sku", unique: true
    t.index ["organization_id"], name: "index_products_on_organization_id"
    t.index ["product_type"], name: "index_products_on_product_type"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "organization_id", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "warehouses", force: :cascade do |t|
    t.integer "organization_id", null: false
    t.string "code", null: false
    t.string "name", null: false
    t.boolean "is_active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "code"], name: "index_warehouses_on_organization_id_and_code", unique: true
    t.index ["organization_id", "is_active"], name: "index_warehouses_on_organization_id_and_is_active"
    t.index ["organization_id", "name"], name: "index_warehouses_on_organization_id_and_name"
    t.index ["organization_id"], name: "index_warehouses_on_organization_id"
  end

  add_foreign_key "addresses", "organizations"
  add_foreign_key "companies", "organizations"
  add_foreign_key "contacts", "companies"
  add_foreign_key "contacts", "organizations"
  add_foreign_key "products", "organizations"
  add_foreign_key "users", "organizations"
  add_foreign_key "warehouses", "organizations"
end
