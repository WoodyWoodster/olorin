class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :addressable, polymorphic: true, null: false
      t.string :address_type, null: false
      t.string :street, null: false
      t.string :street2
      t.string :city, null: false
      t.string :state
      t.string :postal_code
      t.string :country, null: false

      t.timestamps
    end

    add_index :addresses, [ :organization_id, :addressable_type, :addressable_id ], name: 'index_addresses_on_org_and_addressable'
    add_index :addresses, [ :addressable_type, :addressable_id, :address_type ], name: 'index_addresses_on_addressable_and_type'
  end
end
