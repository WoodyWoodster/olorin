# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :sku, null: false
      t.string :name, null: false
      t.text :description
      t.string :product_type, null: false
      t.string :unit_of_measure, null: false
      t.decimal :cost, precision: 10, scale: 2
      t.decimal :price, precision: 10, scale: 2
      t.boolean :is_manufactured, default: false, null: false
      t.boolean :is_active, default: true, null: false

      t.timestamps
    end

    add_index :products, [:organization_id, :sku], unique: true
    add_index :products, :product_type
    add_index :products, [:organization_id, :name]
    add_index :products, [:organization_id, :is_active]
  end
end
