require 'support_mongoid'
require 'mongoid_user'

describe Mongodb::User do
  it { should have_fields(:email, :token, :password_hash) }
  it { should embed_many(:tasks) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }

  it '.extendet_new' do
    user = double('user')
    allow(Mongodb::User).to receive(:new).with(email: 'email').and_return(user)
    allow(user).to receive(:password=).with('password')
    allow(Mongodb::User).to receive(:generate_token).and_return('generated')
    allow(user).to receive(:token=).with('generated')
    expect(Mongodb::User.extendet_new(email: 'email', pw: 'password', token: 'token'))
    .to eql(user)
  end

  context '.current' do
    it 'fails' do
      allow(Mongodb::User).to receive(:find_by).with({ token: 'token' }).and_return(false)
      expect(Mongodb::User.current('token')).to be_instance_of(Mongodb::NullUser)
    end

    it 'succeeds' do
      user = double('user')
      allow(Mongodb::User).to receive(:find_by).with({ token: 'token' }).and_return(user)
      expect(Mongodb::User.current('token')).to eql(user)
    end
  end

  it '#password' do
    skip
  end

  it '#password=' do
    skip
  end

  it '#compare_password' do
    skip
  end

  it '#authenticated?' do
      user = Mongodb::User.new(email: 'x', token: 'token')
      allow(Session).to receive(:secure_compare).with('given_token', 'token')
      user.authenticated?('given_token')
  end

  context '.login' do
    it 'fails' do
      user = double('user', compare_password: false)
      allow(Mongodb::User).to receive(:find_by).with(email: 'email').and_return(user)
      expect(Mongodb::User.login('email', 'pw')).to be_instance_of(Mongodb::NullUser)
    end

    it 'succeeds' do
      user = double('user', compare_password: true)
      allow(user).to receive(:token=).with('token')
      allow(Mongodb::User).to receive(:find_by).with(email: 'email').and_return(user)
      allow(Mongodb::User).to receive(:generate_token).and_return('token')
      expect(Mongodb::User.login('email', 'pw')).to eql(user)
    end
  end

  it '.generate_token' do
    skip
  end

  it '#to_bearer' do
    user = Mongodb::User.new(email: 'x', token: 'token')
    expect(user.to_bearer).to eql({ access_token: 'token', token_type: 'bearer' })
  end

  it '#to_json' do
    user = Mongodb::User.new(email: 'x')
    expect(user.to_json).to eql("{\"user\":#{user.as_json}}")
  end
end

describe Mongodb::NullUser do
  it 'returns false' do
    null_user = Mongodb::NullUser.new
    expect(null_user.missing_method).to be false
  end
end
