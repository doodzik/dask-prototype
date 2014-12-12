require 'Mongoid'

# top comment
module Mongodb
  # top comment
  class Task
    include Mongoid::Document

    @weekdays = %w(sunday monday tuesday wednesday thursday friday saturday)

    validates :days, inclusion: { in: [0..@weekdays.length] }
    validates :name, presence: true, uniqueness: true

    field :name
    field :checked, type: Time
    field :days, type: Array

    belongs_to :user

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
