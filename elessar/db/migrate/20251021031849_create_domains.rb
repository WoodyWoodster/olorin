# frozen_string_literal: true

class CreateDomains < ActiveRecord::Migration[8.0]
  def change
    create_table :domains do |t|
      t.references :app, null: false, foreign_key: true
      t.string :hostname, null: false
      t.boolean :ssl_enabled, default: false, null: false
      t.datetime :verified_at

      t.timestamps
    end

    add_index :domains, :hostname, unique: true
    add_index :domains, [ :app_id, :hostname ]
  end
end
