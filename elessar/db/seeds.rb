# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

if Rails.env.development?
  puts "🌱 Seeding development data..."

  # Create Organization
  org = Organization.find_or_create_by!(subdomain: "acme") do |o|
    o.name = "Acme Manufacturing Inc."
  end
  puts "✅ Created organization: #{org.name}"

  # Set current organization context for seed data
  Current.organization = org

  # Create test user
  user = User.find_or_create_by!(email: "admin@acme.com") do |u|
    u.password = "password"
    u.password_confirmation = "password"
    u.organization = org
  end
  puts "✅ Created user: #{user.email} / password"

  # Create Warehouses
  main_warehouse = Warehouse.find_or_create_by!(code: "MAIN", organization: org) do |w|
    w.name = "Main Warehouse"
  end

  secondary_warehouse = Warehouse.find_or_create_by!(code: "SEC", organization: org) do |w|
    w.name = "Secondary Warehouse"
  end
  puts "✅ Created #{Warehouse.count} warehouses"

  # Create warehouse addresses
  main_warehouse.addresses.find_or_create_by!(address_type: :warehouse) do |addr|
    addr.street = "123 Manufacturing Dr"
    addr.city = "Industrial City"
    addr.state = "CA"
    addr.postal_code = "90210"
    addr.country = "USA"
  end

  # Create Products - Raw Materials
  steel_sheet = Product.find_or_create_by!(sku: "RM-STL-001", organization: org) do |p|
    p.name = "Steel Sheet 4x8"
    p.description = "Cold-rolled steel sheet, 4ft x 8ft"
    p.product_type = :raw_material
    p.unit_of_measure = :piece
    p.cost = 150.00
    p.price = 200.00
  end

  aluminum_bar = Product.find_or_create_by!(sku: "RM-ALM-001", organization: org) do |p|
    p.name = "Aluminum Bar Stock"
    p.description = "Aluminum bar, 1 inch diameter"
    p.product_type = :raw_material
    p.unit_of_measure = :meter
    p.cost = 25.00
    p.price = 35.00
  end

  plastic_pellets = Product.find_or_create_by!(sku: "RM-PLS-001", organization: org) do |p|
    p.name = "Plastic Pellets - ABS"
    p.description = "ABS plastic pellets for injection molding"
    p.product_type = :raw_material
    p.unit_of_measure = :kilogram
    p.cost = 3.50
    p.price = 5.00
  end

  # Create Products - Components
  bracket = Product.find_or_create_by!(sku: "CMP-BRK-001", organization: org) do |p|
    p.name = "Steel Mounting Bracket"
    p.description = "Laser-cut mounting bracket"
    p.product_type = :component
    p.unit_of_measure = :piece
    p.cost = 8.50
    p.price = 15.00
    p.is_manufactured = true
  end

  handle = Product.find_or_create_by!(sku: "CMP-HDL-001", organization: org) do |p|
    p.name = "Aluminum Handle"
    p.description = "CNC-machined aluminum handle"
    p.product_type = :component
    p.unit_of_measure = :piece
    p.cost = 12.00
    p.price = 20.00
    p.is_manufactured = true
  end

  # Create Products - Finished Goods
  widget = Product.find_or_create_by!(sku: "FG-WDG-001", organization: org) do |p|
    p.name = "Industrial Widget Assembly"
    p.description = "Complete widget assembly with bracket and handle"
    p.product_type = :finished_good
    p.unit_of_measure = :piece
    p.cost = 45.00
    p.price = 99.99
    p.is_manufactured = true
  end
  puts "✅ Created #{Product.count} products"

  # Create Companies - Customers
  acme_corp = Company.find_or_create_by!(name: "Acme Corporation", organization: org) do |c|
    c.company_type = :customer
    c.tax_id = "12-3456789"
    c.email = "orders@acmecorp.com"
    c.phone = "(555) 123-4567"
  end

  global_industries = Company.find_or_create_by!(name: "Global Industries LLC", organization: org) do |c|
    c.company_type = :customer
    c.tax_id = "98-7654321"
    c.email = "procurement@globalind.com"
    c.phone = "(555) 987-6543"
  end

  # Create Companies - Suppliers
  steel_supply = Company.find_or_create_by!(name: "Steel Supply Co", organization: org) do |c|
    c.company_type = :supplier
    c.email = "sales@steelsupply.com"
    c.phone = "(555) 111-2222"
  end

  metal_warehouse = Company.find_or_create_by!(name: "Metal Warehouse Inc", organization: org) do |c|
    c.company_type = :both
    c.email = "info@metalwarehouse.com"
    c.phone = "(555) 333-4444"
  end
  puts "✅ Created #{Company.count} companies"

  # Create Contacts
  acme_corp.contacts.find_or_create_by!(email: "john.doe@acmecorp.com") do |contact|
    contact.first_name = "John"
    contact.last_name = "Doe"
    contact.phone = "(555) 123-4567"
    contact.role = "Purchasing Manager"
    contact.is_primary = true
  end

  global_industries.contacts.find_or_create_by!(email: "jane.smith@globalind.com") do |contact|
    contact.first_name = "Jane"
    contact.last_name = "Smith"
    contact.phone = "(555) 987-6543"
    contact.role = "Procurement Director"
    contact.is_primary = true
  end

  steel_supply.contacts.find_or_create_by!(email: "bob.jones@steelsupply.com") do |contact|
    contact.first_name = "Bob"
    contact.last_name = "Jones"
    contact.phone = "(555) 111-2222"
    contact.role = "Sales Representative"
    contact.is_primary = true
  end
  puts "✅ Created #{Contact.count} contacts"

  # Create Addresses for Companies
  acme_corp.addresses.find_or_create_by!(address_type: :billing) do |addr|
    addr.street = "456 Corporate Blvd"
    addr.city = "Business City"
    addr.state = "NY"
    addr.postal_code = "10001"
    addr.country = "USA"
  end

  acme_corp.addresses.find_or_create_by!(address_type: :shipping) do |addr|
    addr.street = "789 Warehouse Way"
    addr.city = "Business City"
    addr.state = "NY"
    addr.postal_code = "10002"
    addr.country = "USA"
  end

  global_industries.addresses.find_or_create_by!(address_type: :billing) do |addr|
    addr.street = "321 Enterprise Ave"
    addr.city = "Commerce Town"
    addr.state = "TX"
    addr.postal_code = "75001"
    addr.country = "USA"
  end

  steel_supply.addresses.find_or_create_by!(address_type: :billing) do |addr|
    addr.street = "555 Industrial Pkwy"
    addr.city = "Supply City"
    addr.state = "OH"
    addr.postal_code = "44101"
    addr.country = "USA"
  end
  puts "✅ Created #{Address.count} addresses"

  puts "🎉 Seeding complete!"
  puts ""
  puts "📋 Summary:"
  puts "  Organizations: #{Organization.count}"
  puts "  Users: #{User.count}"
  puts "  Warehouses: #{Warehouse.count}"
  puts "  Products: #{Product.count}"
  puts "  Companies: #{Company.count}"
  puts "  Contacts: #{Contact.count}"
  puts "  Addresses: #{Address.count}"
  puts ""
  puts "🔐 Login credentials:"
  puts "  Email: admin@acme.com"
  puts "  Password: password"
end
