class Sprint < ActiveRecord::Base
  include AASM

  has_many :daily_rations

  aasm column: 'state' do
    state :pending, initial: true
    state :running
    state :closed

    event :run do
      transitions from: :pending, to: :running
    end

    event :close do
      transitions from: :running, to: :closed
    end
  end

end
