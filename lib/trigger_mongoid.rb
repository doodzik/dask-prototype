require 'mongoid'

module Mongodb
  # top comment
  class Trigger
    include Mongoid::Document

    # validates days in api on post and put route
    validates :name, presence: true
    validates_length_of :name, within: 1..140

    field :name,  type: String
    field :tasks, type: Array, default: []

    embedded_in :user
  end
end
