class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :update, :destroy]
  before_action :set_rental, only: [:create,]
  # GET /bookings
  def index
    @bookings = Booking.by_rental(params[:rental_id])
    json_response(@bookings)
  end

  # POST /bookings
  def create
    @booking = @rental.bookings.build(booking_params)
    @booking.save
    json_response(@booking, :created)
  end

  # GET /bookings/:id
  def show
    json_response(@booking)
  end

  # PUT /bookings/:id
  def update
    @booking.update!(booking_params)
    head :no_content
  end

  # DELETE /bookings/:id
  def destroy
    @booking.destroy
    head :no_content
  end

  private

  def booking_params
    # whitelist params
    params.require(:booking).permit(:start_at, :end_at, :client_email, :price, :id, :rental_id)
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def set_rental
    @rental = Rental.find(params[:rental_id])
  end
end
