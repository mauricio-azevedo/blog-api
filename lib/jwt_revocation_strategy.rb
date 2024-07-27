module JwtRevocationStrategy
  extend ActiveSupport::Concern

  included do
    has_many :refresh_tokens, dependent: :destroy
  end

  def self.jwt_revoked?(payload, user)
    !user.refresh_tokens.exists?(token: payload['jti'])
  end

  def self.revoke_jwt(payload, user)
    user.refresh_tokens.find_by(token: payload['jti'])&.destroy
  end
end
