require 'support_mongoid'
require 'task_mongoid'

describe Mongodb::Task do
  it { should have_fields(:name) }

  it do
    should have_field(:checked).of_type(Time).with_default_value_of(Time.at(0))
  end

  it { should have_field(:days).of_type(Array).with_default_value_of([]) }

  it { should be_embedded_in(:user) }

  # TODO: test validation
  # it { should validate_inclusion_of(:days).to_allow([1..7]) }
  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name).within(1..140) }

  it '#check' do
    task = described_class.new(name: 'x')
    task.check(123)
    expect(task.checked).to eql(Time.at(123))
  end

  it '#uncheck' do
    task = described_class.new(name: 'x', checked: Time.at(123))
    task.uncheck
    expect(task.checked).to eql(Time.at(0))
  end

  describe '#checked?' do
    it 'true when checked' do
      task = described_class.new(name: 'x', checked: Time.at(123))
      expect(task.checked?).to be true
    end

    it 'false when checked' do
      task = described_class.new(name: 'x', checked: Time.at(0))
      expect(task.checked?).to be false
    end
  end
end
