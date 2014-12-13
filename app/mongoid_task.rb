require 'mongoid'

# top comment
module Mongodb
  # top comment
  class Task
    include Mongoid::Document

    @weekdays = %w(sunday monday tuesday wednesday thursday friday saturday)

    validates :days, inclusion: { in: [0..7] }
    validates :name, presence: true
    validates_length_of :name, within: 1..140

    field :name
    field :checked, type: Time, default: Time.at(0)
    field :days, type: Array, default: []

    embedded_in :user

    def checked?
      checked != Time.at(0)
    end

    def uncheck
      self.checked = Time.at(0)
    end

    def check(time)
      self.checked = Time.at(time)
    end
  end
end
