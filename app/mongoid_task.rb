require 'Mongoid'

# top comment
module Mongodb
  # top comment
  class Task
    include Mongoid::Document

    attr_reader :weekdays
    @weekdays = %w(sunday monday tuesday wednesday thursday friday saturday)

    validates :days, inclusion: { in: [0..weekdays.lenght] }
    validates :name, presence: true, uniqueness: true

    field :name
    field :checked, type: Time
    field :days, type: Array

    belongs_to :user

    scope :for_this_day, :english, -> { where(:days.in => [Time.now.wday]) }

    def checked?
      checked.wday == Time.now.wday
    end

    def check
      checked = checked? ? Time.at(628_232_400) : Time.now
    end

    def to_h
      hash = Hash[attributes]
      hash.checked = checked?
      hash
    end
  end
end
