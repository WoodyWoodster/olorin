# frozen_string_literal: true

Devise.setup do |config|
  # The secret key used by Devise. Devise uses this key to generate
  # random tokens. Changing this key will render invalid all existing
  # confirmation, reset password and unlock tokens in the database.
  config.secret_key = ENV["DEVISE_JWT_SECRET_KEY"] || Rails.application.credentials.secret_key_base

  # ==> Mailer Configuration
  config.mailer_sender = "please-change-me-at-config-initializers-devise@example.com"

  # Configure the class responsible to send e-mails.
  # config.mailer = 'Devise::Mailer'

  # Configure the parent class responsible to send e-mails.
  # config.parent_mailer = 'ActionMailer::Base'

  # Tell Devise this is an API-only app (no flash messages or redirects)
  config.navigational_formats = []

  # ==> ORM configuration
  require "devise/orm/active_record"

  # ==> Configuration for :database_authenticatable
  config.stretches = Rails.env.test? ? 1 : 12

  # ==> Configuration for :validatable
  config.password_length = 6..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  # ==> Configuration for :timeoutable
  # config.timeout_in = 30.minutes

  # ==> Configuration for :lockable
  # config.lock_strategy = :failed_attempts
  # config.unlock_keys = [:email]
  # config.unlock_strategy = :both
  # config.maximum_attempts = 20
  # config.unlock_in = 1.hour
  # config.last_attempt_warning = true

  # ==> Configuration for :recoverable
  config.reset_password_within = 6.hours

  # ==> Configuration for :rememberable
  config.remember_for = 2.weeks

  # ==> Configuration for :validatable
  config.password_length = 6..128

  # ==> Navigation configuration
  config.sign_out_via = :delete

  # ==> JWT Configuration
  config.jwt do |jwt|
    jwt.secret = ENV["DEVISE_JWT_SECRET_KEY"] || Rails.application.credentials.secret_key_base
    jwt.dispatch_requests = [
      [ "POST", %r{^/api/auth/login$} ],
      [ "POST", %r{^/api/auth/signup$} ]
    ]
    jwt.revocation_requests = [
      [ "DELETE", %r{^/api/auth/logout$} ]
    ]
    jwt.expiration_time = 1.day.to_i
  end
end
