require 'rails_helper'

RSpec.describe User, type: :model do
  describe ".find_or_create_for_developer" do
    it "should create a User for first time user" do
      token = { 'info' => { 'email' => nil, 'name' => nil } }
      user = User.find_or_create_for_developer(token)

      expect(user).to be_persisted
      expect(user.provider).to eq("developer")
      expect(user.uid).to eq("1")
      expect(user.full_name).to eq("developer")
    end

    it "should reuse an existing User if the access token matches" do
      token = { 'uid' => '1', 'provider' => 'developer',
                'info' => { 'email' => nil, 'name' => nil }
              }
      user = User.find_or_create_for_developer(token)
    end
  end

  describe ".find_or_create_for_shibboleth" do
    it "should create a User when a user is first authenticated" do
      token = { 'uid' => 'test_user', 'provider' => 'shibboleth',
                'info' => { 'email' => nil, 'name' => nil }
              }

      user = User.find_or_create_for_shibboleth(token)
      expect(user).to be_persisted
      expect(user.provider).to eq("shibboleth")
      expect(user.uid).to eq("test_user")
    end
  end
end
