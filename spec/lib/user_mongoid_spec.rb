require 'support_mongoid'
require 'user_mongoid'

describe Mongodb::User do
  it { should have_fields(:email, :token, :password_hash) }
  it { should embed_many(:tasks) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }

  it '.extendet_new' do
    user = instance_double('User')
    allow(Mongodb::User).to receive(:new).with(email: 'email').and_return(user)
    allow(user).to receive(:password=).with('password')
    allow(Mongodb::User).to receive(:generate_token).and_return('generated')
    allow(user).to receive(:token=).with('generated')
    expect(Mongodb::User.extendet_new(email: 'email', pw: 'password'))
      .to eql(user)
  end

  context '.current' do
    it 'fails' do
      allow(Mongodb::User).to receive(:find_by)
        .with(token: 'token').and_return(false)
      expect(Mongodb::User.current('token'))
        .to be_instance_of(Mongodb::NullUser)
    end

    it 'succeeds' do
      user = instance_double('User')
      allow(Mongodb::User).to receive(:find_by)
        .with(token: 'token').and_return(user)
      expect(Mongodb::User.current('token')).to eql(user)
    end
  end

  it '#password' do
    user = Mongodb::User.new(password_hash: 'hallo', email: 'x', token: 'token')
    allow(Mongodb::User::Password).to receive(:new)
      .with('hallo').and_return('hallo')
    user.password
    expect(user.instance_variable_get(:@password)).to eql('hallo')
    allow(Mongodb::User::Password).to receive(:new)
      .with('hallo2').and_return('hallo2')
    user.password
    expect(user.instance_variable_get(:@password)).to eql('hallo')
  end

  it '#password=' do
    user = Mongodb::User.new(email: 'x', token: 'token')
    allow(Mongodb::User::Password).to receive(:create)
      .with('hallo').and_return('Hallo')
    user.password = 'hallo'
    expect(user.password_hash).to eql('Hallo')
  end

  it '#compare_password' do
    user = Mongodb::User.new(email: 'x', token: 'token')
    allow(user).to receive(:password).and_return('hallo')
    expect(user.compare_password('hallo')).to be true
  end

  it '#authenticated?' do
    user = Mongodb::User.new(email: 'x', token: 'token')
    allow(Auth).to receive(:secure_compare).with('given_token', 'token')
    user.authenticated?('given_token')
  end

  context '.login' do
    it 'fails' do
      user = instance_double('User', compare_password: false)
      allow(Mongodb::User).to receive(:find_by)
        .with(email: 'email').and_return(user)
      expect(Mongodb::User.login('email', 'pw'))
        .to be_instance_of(Mongodb::NullUser)
    end

    it 'succeeds' do
      user = instance_double('User', compare_password: true)
      allow(user).to receive(:token=).with('token')
      allow(Mongodb::User).to receive(:find_by)
        .with(email: 'email').and_return(user)
      allow(Mongodb::User).to receive(:generate_token).and_return('token')
      expect(Mongodb::User.login('email', 'pw')).to eql(user)
    end
  end

  it '.generate_token' do
    allow(Auth).to receive(:generate_unique_token)
      .and_yield('value').and_return('valueX')
    allow(Mongodb::User).to receive(:find_by).with(token: 'value')
    expect(Mongodb::User.generate_token).to eql('valueX')
  end

  it '#to_bearer' do
    user = Mongodb::User.new(email: 'x', token: 'token')
    expect(user.to_bearer).to eql(access_token: 'token', token_type: 'bearer')
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
