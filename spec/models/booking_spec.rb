require 'rails_helper'

RSpec.describe Booking, type: :model do
  it { should belong_to(:rental) }
  it { should validate_presence_of(:start_at) }
  it { should validate_presence_of(:end_at) }
  it { should validate_presence_of(:client_email) }
  it { should validate_presence_of(:price) }

  it "should validate that periods do not overlap" do
    rental = FactoryGirl.create(:rental)
    first_booking = FactoryGirl.create(:booking, :rental => rental)
    overlapped_booking = FactoryGirl.build(:booking, :rental => rental)
    overlapped_booking.valid?
    overlapped_booking.errors[:period].first.should include('not available')
  end

  it "should validate that the price is valid" do
    rental = FactoryGirl.create(:rental, daily_rate: 120)
    booking = FactoryGirl.build(:booking, start_at: '2017-09-19', end_at: '2017-09-20', price: 111, :rental => rental)
    booking.valid?
    booking.errors[:price].first.should include('should be valid')
  end

  it "should validate that the reservation is possible only for at least one night stay" do
    rental = FactoryGirl.create(:rental, daily_rate: 120)
    booking = FactoryGirl.build(:booking, start_at: '2017-09-19', end_at: '2017-09-19', price: 0, :rental => rental)
    booking.valid?
    booking.errors[:duration_of_a_period].first.should include('cannot be less than one night stay')
  end
end
