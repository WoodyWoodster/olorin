# frozen_string_literal: true

class CreateEnvVars < ActiveRecord::Migration[8.0]
  def change
    create_table :env_vars do |t|
      t.references :app, null: false, foreign_key: true
      t.string :key, null: false
      t.text :value

      t.timestamps
    end

    add_index :env_vars, [ :app_id, :key ], unique: true
  end
end
