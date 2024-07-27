class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtRevocationStrategy

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :refresh_tokens, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: :password

  def generate_access_token
    Warden::JWTAuth::UserEncoder.new.call(self, :user, nil).first
  end

  def generate_refresh_token
    token = SecureRandom.uuid
    expires_at = 3.months.from_now
    refresh_tokens.create!(token: token, expires_at: expires_at)
    token
  end

  def refresh_token_valid?(token)
    refresh_tokens.exists?(token: token, expires_at: Time.current..)
  end
end
