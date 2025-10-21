# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured, as per the readme at https://github.com/rswag/rswag#3-output-the-generated-swagger-as-json
  config.openapi_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Olorin ERP API V1',
        version: 'v1',
        description: 'Manufacturing ERP system API documentation'
      },
      paths: {},
      servers: [
        {
          url: 'http://localhost:3000',
          description: 'Development server'
        },
        {
          url: 'https://{subdomain}.olorin.com',
          description: 'Production server',
          variables: {
            subdomain: {
              default: 'app',
              description: 'Your organization subdomain'
            }
          }
        }
      ],
      components: {
        securitySchemes: {
          Bearer: {
            type: :http,
            scheme: :bearer,
            bearerFormat: 'JWT',
            description: 'JWT token from login endpoint'
          }
        },
        schemas: {
          Error: {
            type: :object,
            properties: {
              errors: {
                type: :array,
                items: { type: :string }
              }
            },
            required: [ 'errors' ]
          },
          Product: {
            type: :object,
            properties: {
              id: { type: :integer },
              sku: { type: :string },
              name: { type: :string },
              description: { type: :string, nullable: true },
              product_type: { type: :string, enum: [ 'raw_material', 'component', 'finished_good', 'service' ] },
              unit_of_measure: { type: :string },
              cost: { type: :number, format: :float, nullable: true },
              price: { type: :number, format: :float, nullable: true },
              is_manufactured: { type: :boolean },
              is_active: { type: :boolean },
              created_at: { type: :string, format: 'date-time' },
              updated_at: { type: :string, format: 'date-time' }
            },
            required: [ 'id', 'sku', 'name', 'product_type', 'unit_of_measure' ]
          },
          Company: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              company_type: { type: :string, enum: [ 'customer', 'supplier', 'both' ] },
              tax_id: { type: :string, nullable: true },
              website: { type: :string, nullable: true },
              phone: { type: :string, nullable: true },
              email: { type: :string, nullable: true },
              is_active: { type: :boolean },
              created_at: { type: :string, format: 'date-time' },
              updated_at: { type: :string, format: 'date-time' }
            },
            required: [ 'id', 'name', 'company_type' ]
          },
          Warehouse: {
            type: :object,
            properties: {
              id: { type: :integer },
              code: { type: :string },
              name: { type: :string },
              is_active: { type: :boolean },
              created_at: { type: :string, format: 'date-time' },
              updated_at: { type: :string, format: 'date-time' }
            },
            required: [ 'id', 'code', 'name' ]
          }
        }
      },
      security: [
        { Bearer: [] }
      ]
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml
end
