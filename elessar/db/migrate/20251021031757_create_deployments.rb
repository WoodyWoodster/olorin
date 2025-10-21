# frozen_string_literal: true

class CreateDeployments < ActiveRecord::Migration[8.0]
  def change
    create_table :deployments do |t|
      t.references :app, null: false, foreign_key: true
      t.string :commit_sha, null: false
      t.string :status, null: false, default: "pending"
      t.text :build_logs
      t.datetime :deployed_at

      t.timestamps
    end

    add_index :deployments, [ :app_id, :created_at ]
    add_index :deployments, :status
  end
end
