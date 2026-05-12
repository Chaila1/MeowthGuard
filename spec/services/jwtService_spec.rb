require 'rails_helper'

RSpec.describe JwtService  do
  describe '.encode' do
    let(:payload) {{user_id: 1, username: "mattyb"}}

    it 'Returns a generated JWT token string' do
      token = JwtService.encode(payload)
      expect(token).to be_a(String)
      expect(token.split(".").length).to eq(3)
    end

    it 'has an expiration date' do
      token = JwtService.encode(payload)
      decodedPayload = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]

      expect(decodedPayload).to have_key("exp")
    end
  end
end
