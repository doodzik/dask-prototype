require 'mongoid'

module Mongodb
  # top comment
  class Task
    include Mongoid::Document

    @weekdays = %w(sunday monday tuesday wednesday thursday friday saturday)

    # TODO: day validation
    # validates :days, inclusion: { in: [0..6] }
    validates :name, presence: true
    validates_length_of :name, within: 1..140

    field :name
    # Time.at(0) (timestamp-epoch) is a unchecked checked
    field :checked, type: Time, default: Time.at(0)
    field :days, type: Array, default: []

    embedded_in :user

    # checks if task is checked
    # @return [Boolean]
    def checked?
      checked != Time.at(0)
    end

    # sets checked to unchecked
    # @return [void]
    def uncheck
      self.checked = Time.at(0)
    end

    # sets checked to time
    # @param time [Time]
    # @return [void]
    def check(time)
      self.checked = Time.at(time)
    end
  end
end
