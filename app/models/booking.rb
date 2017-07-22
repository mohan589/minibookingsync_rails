class Booking < ApplicationRecord
  belongs_to :rental

  validates :start_at, :end_at, :client_email, :price, presence: true
  validate :period_is_valid
  validate :price_is_valid
  validate :at_least_one_night_stay
  validate :period_do_not_overlap_existing_ones

  scope :by_rental, -> rental_id {
    where(rental_id: rental_id)
  }

  scope :all_except, ->(booking) { where.not(id: booking) }

  scope :overlaping_periods, -> booking {
    where('? >= start_at AND end_at >= ?', booking.end_at, booking.start_at)
  }

  private
    def period_is_valid
      # if self.end_at.nil? || self.start_at.nil?
      #   errors.add(:period_parameters, "should be non empty and valid")
      # elsif self.price != (self.end_at.to_date - self.start_at.to_date).to_i * self.rental.daily_rate
      #   errors.add(:price, "should be valid")
      # end
    end

    def price_is_valid
      # return unless errors.blank?

      # if self.price != (self.end_at.to_date - self.start_at.to_date).to_i * self.rental.daily_rate
      #   errors.add(:price, "should be valid")
      # end
    end

    def at_least_one_night_stay
      return unless errors.blank?

      if (self.end_at.to_date - self.start_at.to_date).to_i < 1
        errors.add(:duration_of_a_period, "specified by start_at and end_at parameters cannot be less than one night stay")
      end
    end

    def period_do_not_overlap_existing_ones
      return unless errors.blank?

      overlaps = self.rental.bookings.all_except(self).overlaping_periods(self)
      unless overlaps.empty?
        errors.add(:period, 'specified by start_at and end_at parameters is not available for booking')
      end
    end
end
