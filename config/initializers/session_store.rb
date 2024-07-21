Rails.application.config.session_store :cookie_store, key: '_session_id', same_site: :none, secure: Rails.env.production?
