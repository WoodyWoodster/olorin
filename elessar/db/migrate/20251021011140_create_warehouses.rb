class CreateWarehouses < ActiveRecord::Migration[8.0]
  def change
    create_table :warehouses do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :code, null: false
      t.string :name, null: false
      t.boolean :is_active, default: true, null: false

      t.timestamps
    end

    add_index :warehouses, [:organization_id, :code], unique: true
    add_index :warehouses, [:organization_id, :name]
    add_index :warehouses, [:organization_id, :is_active]
  end
end
