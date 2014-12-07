=begin
require 'support'
require 'support_mongoid'
require 'mongoid_user'

describe Mongodb::User do
 it { should have_fields(:email, :token, :password_hash) }
 it { should have_many(:tasks) }

 it { should validate_presence_of(:email) }
 it { should validate_uniqueness_of(:email).case_insensitive }

end
=end
