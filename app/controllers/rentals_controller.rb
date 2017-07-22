class RentalsController < ApplicationController
  before_action :set_rental, only: [:show, :update, :destroy]

  # GET /rentals
  def index
    @rentals = Rental.all
    json_response(@rentals)
  end

  # POST /rentals
  def create
    @rental = Rental.create!(rental_params)
    json_response(@rental, :created)
  end

  # GET /rentals/:id
  def show
    json_response(@rental)
  end

  # PUT /rentals/:id
  def update
    @rental.update!(rental_params)
    head :no_content
  end

  # DELETE /rentals/:id
  def destroy
    @rental.destroy
    head :no_content
  end

  private

  def rental_params
    # whitelist params
    params.require(:rental).permit(:id, :name, :daily_rate)
  end

  def set_rental
    @rental = Rental.find(params[:id])
  end
end
