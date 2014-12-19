require 'support_mongoid'
require 'user_mongoid'

describe Mongodb do
  describe Mongodb::User do
    it { should have_fields(:email, :token, :password_hash) }
    it { should embed_many(:tasks) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }

    it '.extendet_new' do
      user = instance_double('User')
      allow(described_class).to receive(:new)
        .with(email: 'email').and_return(user)
      allow(user).to receive(:password=).with('password')
      allow(Auth).to receive(:generate_unique_user_token)
        .and_return('generated')
      allow(user).to receive(:token=).with('generated')
      expect(described_class.extendet_new(email: 'email', pw: 'password'))
        .to eql(user)
    end

    context '.current' do
      it 'fails' do
        allow(described_class).to receive(:find_by)
          .with(token: 'token').and_return(false)
        expect(described_class.current('token'))
          .to be_instance_of(Mongodb::NullUser)
      end

      it 'succeeds' do
        user = instance_double('User')
        allow(described_class).to receive(:find_by)
          .with(token: 'token').and_return(user)
        expect(described_class.current('token')).to eql(user)
      end
    end

    it '#password' do
      user = described_class.new(password_hash: 'hallo',
                                 email: 'x', token: 'token')
      allow(described_class::Password).to receive(:new)
        .with('hallo').and_return('hallo')
      user.password
      expect(user.instance_variable_get(:@password)).to eql('hallo')
      allow(described_class::Password).to receive(:new)
        .with('hallo2').and_return('hallo2')
      user.password
      expect(user.instance_variable_get(:@password)).to eql('hallo')
    end

    it '#password=' do
      user = described_class.new(email: 'x', token: 'token')
      allow(described_class::Password).to receive(:create)
        .with('hallo').and_return('Hallo')
      user.password = 'hallo'
      expect(user.password_hash).to eql('Hallo')
    end

    it '#compare_password' do
      user = described_class.new(email: 'x', token: 'token')
      allow(user).to receive(:password).and_return('hallo')
      expect(user.compare_password('hallo')).to be true
    end

    it '#authenticated?' do
      user = described_class.new(email: 'x', token: 'token')
      allow(Auth).to receive(:secure_compare).with('given_token', 'token')
      user.authenticated?('given_token')
    end

    context '.login' do
      it 'fails' do
        user = instance_double('User', compare_password: false)
        allow(described_class).to receive(:find_by)
          .with(email: 'email').and_return(user)
        expect(described_class.login('email', 'pw'))
          .to be_instance_of(Mongodb::NullUser)
      end

      it 'succeeds' do
        user = instance_double('User', compare_password: true)
        allow(user).to receive(:token=).with('token')
        allow(described_class).to receive(:find_by)
          .with(email: 'email').and_return(user)
        allow(Auth).to receive(:generate_unique_user_token).and_return('token')
        expect(described_class.login('email', 'pw')).to eql(user)
      end
    end

    it '#to_bearer' do
      user = described_class.new(email: 'x', token: 'token')
      expect(user.to_bearer).to eql(access_token: 'token', token_type: 'bearer')
    end

    it '#to_json' do
      user = described_class.new(email: 'x')
      expect(user.to_json).to eql("{\"user\":#{user.as_json}}")
    end
  end

  describe Mongodb::NullUser do
    it 'returns false' do
      null_user = described_class.new
      expect(null_user.missing_method).to be false
    end
  end
end
