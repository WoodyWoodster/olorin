# frozen_string_literal: true

class CreateAddons < ActiveRecord::Migration[8.0]
  def change
    create_table :addons do |t|
      t.references :app, null: false, foreign_key: true
      t.string :addon_type, null: false
      t.string :name, null: false
      t.text :connection_string
      t.string :status, null: false, default: "provisioning"
      t.text :config

      t.timestamps
    end

    add_index :addons, [ :app_id, :addon_type ]
    add_index :addons, :status
  end
end
