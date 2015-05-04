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
    field :days, type: Array, default: [0,1,2,3,4,5,6]

    field :startHour,   type: Integer, default: 0
    field :startMinute, type: Integer, default: 0
    field :endHour,     type: Integer, default: 23
    field :endMinute,   type: Integer, default: 59

    field :interval,     type: Integer, default: 1
    field :intervalType, type: Integer, default: 0
    field :startDate,    type: String, default: Time.new.strftime('%Y-%m-%d')

    field :onetime,      type: Boolean, default: false

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
