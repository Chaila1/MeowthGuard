class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true

  MAX_LOG_ATTEMPTS = 5

  def locked?
    locked_at.present? && locked_at > 15.minutes.ago
  end

  def failedLogin
    increment!(:failed_attempts)
    if failed_attempts >= MAX_LOG_ATTEMPTS
      update(locked_at: Time.current)
    end
  end

  def resetLockout!
    update(failed_attempts: 0, locked_at: nil)
  end
end
