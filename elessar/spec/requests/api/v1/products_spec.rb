# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Api::V1::Products', type: :request do
  # Setup: Create organization and user for authentication
  let(:organization) { Organization.create!(name: 'Test Org', subdomain: 'test') }
  let(:user) { User.create!(email: 'test@example.com', password: 'password', organization: organization) }
  let(:token) do
    post '/api/auth/login', params: { user: { email: user.email, password: 'password' } }
    JSON.parse(response.body)
    response.headers['Authorization'].split(' ').last
  end
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v1/products' do
    get 'List all products' do
      tags 'Products'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter name: :product_type, in: :query, type: :string, required: false,
                description: 'Filter by product type',
                schema: { type: :string, enum: [ 'raw_material', 'component', 'finished_good', 'service' ] }
      parameter name: :is_active, in: :query, type: :boolean, required: false,
                description: 'Filter by active status'
      parameter name: :search, in: :query, type: :string, required: false,
                description: 'Search by name'

      response '200', 'products found' do
        schema type: :array, items: { '$ref' => '#/components/schemas/Product' }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to be_an(Array)
        end
      end

      response '401', 'unauthorized' do
        let(:Authorization) { 'Bearer invalid' }
        run_test!
      end
    end

    post 'Create a product' do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          product: {
            type: :object,
            properties: {
              sku: { type: :string },
              name: { type: :string },
              description: { type: :string },
              product_type: { type: :string, enum: [ 'raw_material', 'component', 'finished_good', 'service' ] },
              unit_of_measure: { type: :string },
              cost: { type: :number },
              price: { type: :number },
              is_manufactured: { type: :boolean },
              is_active: { type: :boolean }
            },
            required: [ 'sku', 'name', 'product_type', 'unit_of_measure' ]
          }
        }
      }

      response '201', 'product created' do
        let(:product) do
          {
            product: {
              sku: 'TEST-001',
              name: 'Test Product',
              product_type: 'raw_material',
              unit_of_measure: 'piece',
              cost: 10.0,
              price: 15.0
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['sku']).to eq('TEST-001')
        end
      end

      response '422', 'invalid request' do
        let(:product) { { product: { name: 'Invalid' } } }
        run_test!
      end
    end
  end

  path '/api/v1/products/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Retrieve a product' do
      tags 'Products'
      produces 'application/json'
      security [ Bearer: [] ]

      response '200', 'product found' do
        schema '$ref' => '#/components/schemas/Product'

        let(:id) { Product.create!(sku: 'GET-001', name: 'Get Product', product_type: 'raw_material', unit_of_measure: 'piece', organization: organization).id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['id']).to eq(id)
        end
      end

      response '404', 'product not found' do
        let(:id) { 99999 }
        run_test!
      end
    end

    patch 'Update a product' do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          product: {
            type: :object,
            properties: {
              name: { type: :string },
              description: { type: :string },
              cost: { type: :number },
              price: { type: :number },
              is_active: { type: :boolean }
            }
          }
        }
      }

      response '200', 'product updated' do
        let(:id) { Product.create!(sku: 'UPD-001', name: 'Update Product', product_type: 'raw_material', unit_of_measure: 'piece', organization: organization).id }
        let(:product) { { product: { name: 'Updated Product' } } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['name']).to eq('Updated Product')
        end
      end
    end

    delete 'Delete a product' do
      tags 'Products'
      security [ Bearer: [] ]

      response '204', 'product deleted' do
        let(:id) { Product.create!(sku: 'DEL-001', name: 'Delete Product', product_type: 'raw_material', unit_of_measure: 'piece', organization: organization).id }

        run_test!
      end

      response '404', 'product not found' do
        let(:id) { 99999 }
        run_test!
      end
    end
  end
end
