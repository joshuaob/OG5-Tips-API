class Account < ApplicationRecord
  before_validation :ensure_otp_secret, on: :create
  before_validation :normalize_email
  has_secure_token :auth_token

  enum :role, { student: 0, admin: 1 }, default: :student

  def totp
    ROTP::TOTP.new(otp_secret, interval: 300) # 5 min expiry
  end

  def generate_otp
    update!(otp_sent_at: Time.current)
    totp.now
  end

  def verify_otp!(code)
    return nil unless totp.verify(code, drift_behind: 1)
  
    regenerate_auth_token
    update!(last_login_at: Time.current)
  
    auth_token
  end

  def can_send_otp?
    otp_sent_at.nil? || otp_sent_at < 30.seconds.ago
  end

  private

  def ensure_otp_secret
    self.otp_secret ||= ROTP::Base32.random
  end

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end
