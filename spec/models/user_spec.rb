require 'rails_helper'

RSpec.describe User, type: :model do
  let(:auth_hash) { OmniAuth::AuthHash.new({
    provider: 'shibboleth',
    uid: '1',
    info: { 'email' => 'test@ucsd.edu', 'name' => 'Dr. Seuss' }
  })}

  let(:invalid_auth_hash_missing_info) { OmniAuth::AuthHash.new({
    provider: 'shibboleth',
    uid: 'test'
  })}

  describe ".find_or_create_for_developer" do
    it "should create a User for first time user" do
      auth_hash.provider = 'developer'
      auth_hash.uid = '1'
      user = User.find_or_create_for_developer(auth_hash)

      expect(user).to be_persisted
      expect(user.provider).to eq("developer")
      expect(user.uid).to eq("1")
      expect(user.full_name).to eq("developer")
    end

    it "should reuse an existing User if the access token matches" do
      auth_hash.provider = 'developer'
      auth_hash.uid = '1'

      user = User.find_or_create_for_developer(auth_hash)

      expect(User.count).to be(1)
    end
  end

  describe ".find_or_create_for_shibboleth" do
    it "should create a User when a user is first authenticated" do
      user = User.find_or_create_for_shibboleth(auth_hash)
      expect(user).to be_persisted
      expect(user.provider).to eq("shibboleth")
      expect(user.uid).to eq("1")
      expect(user.email).to eq('test@ucsd.edu')
      expect(user.full_name).to eq('Dr. Seuss')
    end

    it 'should throw an error with bad or missing response information' do
      expect { User.find_or_create_for_shibboleth(invalid_auth_hash_missing_info) }.to raise_error(StandardError)
    end
  end

  describe '.administrator?' do
    context 'user is not in group' do
      it 'returns false' do
        user = User.find_or_create_for_shibboleth(auth_hash)
        allow(Ldap::Queries).to receive(:hifive_group).with(user.uid).and_return('')
        expect(User.administrator?(user.uid)).to be false
      end
    end
    context 'user is in group' do
      it 'returns true' do
        user = User.find_or_create_for_shibboleth(auth_hash)
        allow(Ldap::Queries).to receive(:hifive_group).with(user.uid).and_return(user.uid)
        expect(User.administrator?(user.uid)).to be true
      end
    end
  end
end
