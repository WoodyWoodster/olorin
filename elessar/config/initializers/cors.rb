# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin Ajax possible.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Allow localhost for development and ALB DNS for production
    origins ENV.fetch("CORS_ORIGINS", "http://localhost:5173").split(",")

    resource "*",
      headers: :any,
      methods: [ :get, :post, :put, :patch, :delete, :options, :head ],
      expose: [ "Authorization" ],  # Expose JWT token header
      credentials: true             # Allow cookies/auth headers
  end
end
