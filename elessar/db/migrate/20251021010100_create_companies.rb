# frozen_string_literal: true

class CreateCompanies < ActiveRecord::Migration[8.0]
  def change
    create_table :companies do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :name, null: false
      t.string :company_type, null: false
      t.string :tax_id
      t.string :website
      t.string :phone
      t.string :email
      t.boolean :is_active, default: true, null: false

      t.timestamps
    end

    add_index :companies, [ :organization_id, :name ]
    add_index :companies, [ :organization_id, :company_type ]
    add_index :companies, [ :organization_id, :is_active ]
  end
end
