source "https://rubygems.org"

ruby "3.3.4"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.3", ">= 7.1.3.4"

# Use sqlite3 as the database for Active Record
gem "sqlite3", "~> 1.4"

# Use PostgreSQL as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder", "~> 2.7"

# Load environment variables from .env file [https://github.com/bkeepers/dotenv]
gem 'dotenv-rails', groups: [:development, :test]

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

# Configure CORS settings
gem 'rack-cors', require: 'rack/cors'

# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
# gem "rack-cors"

# Use Devise for user authentication [https://github.com/heartcombo/devise]
gem 'devise'

# Handle stateless authentication with JSON Web Tokens (JWT)
gem 'jwt'

# Easier pagination handling
gem 'kaminari'

group :test do
  # Matchers for testing Rails models with RSpec [https://github.com/thoughtbot/shoulda-matchers]
  gem 'shoulda-matchers', '~> 5.0'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

