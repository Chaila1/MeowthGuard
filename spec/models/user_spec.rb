require 'rails_helper'

RSpec.describe User, type: :model  do
  describe "Authentication" do
    let(:user) { User.create(username: "Ash", email: "ketchum@pallet.com", password: "pikachu")}

    it 'securely hashes the password via Bcrypt' do
      expect(user.password_digest).not_to eq("pikachu")
      expect(user.authenticate("pikachu")).to be_truthy
    end
  end

  describe 'Lockout Feature' do
    let(:user) {User.create(username: "Brock", email: "Rock@joy.com", password: "officerjenny")}

    it 'increases failed_attempts on a login fail' do
      expect {user.failedLogin}.to change {user.failed_attempts}.by(1)
    end

    it 'locks the use out once it hits MAX_LOG_ATTEMPTS' do
      4.times{user.failedLogin}
      expect(user.locked?).to be_falsey

      user.failedLogin
      expect(user.locked?).to be_truthy
      expect(user.locked_at).to be_present
    end

    it 'failed_attempts reset after 15 mintues' do
      user.update(failed_attempts: 5, locked_at: 16.minutes.ago)
      expect(user.locked?).to be_falsey
    end
  end
end
