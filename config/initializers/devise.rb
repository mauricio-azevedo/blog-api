Devise.setup do |config|
  # ==> Mailer Configuration
  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'

  # ORM configuration
  require 'devise/orm/active_record'

  # Configure which authentication keys should be case-insensitive.
  config.case_insensitive_keys = [:email]

  # Configure which authentication keys should have whitespace stripped.
  config.strip_whitespace_keys = [:email]

  # By default Devise will store the user in session. You can skip storage for
  # particular strategies by setting this option.
  config.skip_session_storage = [:http_auth]

  # Range for password length.
  config.password_length = 6..128

  # Email regex used to validate email formats.
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  # The default HTTP method used to sign out a resource. Default is :delete.
  config.sign_out_via = :delete

  # ==> JWT Configuration
  config.jwt do |jwt|
    jwt.secret = ENV['JWT_SECRET_KEY']
    jwt.dispatch_requests = [
      ['POST', %r{^/users/sign_in$}]
    ]
    jwt.revocation_requests = [
      ['DELETE', %r{^/users/sign_out$}]
    ]
    jwt.expiration_time = 15.minutes.to_i
  end
end
