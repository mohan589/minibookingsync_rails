class Rental < ApplicationRecord
  has_many :bookings, dependent: :destroy

  validates :name, presence: true
  validates :daily_rate, presence: true,
            numericality: { greather_than_or_equal_to: 0, only_integer: true }
end
