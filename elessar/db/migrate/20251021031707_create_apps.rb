# frozen_string_literal: true

class CreateApps < ActiveRecord::Migration[8.0]
  def change
    create_table :apps do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :name, null: false
      t.string :subdomain, null: false
      t.string :git_url
      t.string :status, null: false, default: "stopped"
      t.text :description

      t.timestamps
    end

    add_index :apps, [ :organization_id, :subdomain ], unique: true
    add_index :apps, [ :organization_id, :name ]
    add_index :apps, :status
  end
end
