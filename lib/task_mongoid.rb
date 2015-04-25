require 'mongoid'
require 'active_model'

module Mongodb
  # top comment
  class Task
    include Mongoid::Document
    include ActiveModel::Validations

    @weekdays = %w(sunday monday tuesday wednesday thursday friday saturday)

    # validates days in api on post and put route
    validates :name, presence: true
    validates_length_of :name, within: 1..140

    field :name
    # Time.at(0) (timestamp-epoch) is a unchecked checked
    field :checked, type: Time, default: Time.at(0)
    field :days, type: Array, default: []

    field :startHour,   type: Integer
    field :startMinute, type: Integer
    field :endHour,     type: Integer
    field :endMinute,   type: Integer

    field :interval,     type: Integer
    field :intervalType, type: Integer
    field :startDate,    type: String

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
