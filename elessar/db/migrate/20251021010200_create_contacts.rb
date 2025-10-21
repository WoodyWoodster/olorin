# frozen_string_literal: true

class CreateContacts < ActiveRecord::Migration[8.0]
  def change
    create_table :contacts do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :company, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :mobile
      t.string :role
      t.boolean :is_primary, default: false, null: false

      t.timestamps
    end

    add_index :contacts, [:organization_id, :email]
    add_index :contacts, [:company_id, :is_primary]
  end
end
