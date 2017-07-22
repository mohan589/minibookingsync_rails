require 'rails_helper'

RSpec.describe 'Bookings API', type: :request do
  before :each do          
    @rental = FactoryGirl.create(:rental, daily_rate: 120)
    @booking = FactoryGirl.create(:booking, :rental => @rental)
  end
  
  let!(:booking) { @booking }

  describe 'GET /rentals/:id/bookings' do
    before { get '/rentals/1/bookings', {api_token: "j6hd9@l664HDv2agh"} }

    it 'returns bookings' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(1)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /rentals/:id/bookings' do
    let(:valid_attributes)        { {api_token: "j6hd9@l664HDv2agh", start_at: "2017-07-19", end_at: "2017-07-20", price: 120.0, client_email: 'abcd@a.pl' } }
    let(:incomplete_attributes)   { {api_token: "j6hd9@l664HDv2agh", start_at: "2017-07-19", end_at: "2017-07-20", price: 120.0 } }
    let(:invalid_attributes)      { {api_token: "j6hd9@l664HDv2agh", start_at: "2017-07-191", end_at: "2017-07-20", price: 120.0 } }

    context 'when the request is valid' do
      before { post '/rentals/1/bookings', params: valid_attributes }

      it 'creates a booking' do
        expect(json['start_at']).to eq("2017-07-19T00:00:00.000Z")
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is incomplete (not all params passed)' do
      before { post '/rentals/1/bookings', params: incomplete_attributes }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/can't be blank/)
      end
    end

    context 'when the request is invalid' do
      before { post '/rentals/1/bookings', params: invalid_attributes }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: /)
      end
    end
  end

  describe 'PUT /rentals/:id/bookings/:id' do
    let(:valid_attributes) { {api_token: "j6hd9@l664HDv2agh", start_at: "2017-06-27", end_at: "2017-06-28", price: 120.0 } }

    context 'when the record exists' do
      before { 
        put "/rentals/1/bookings/#{booking.id}", params: valid_attributes
        booking.reload 
      }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'updates the record' do
        expect(booking.start_at).to eq("2017-06-27T00:00:00.000Z")
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'PATCH /rentals/:id/bookings/:id' do
    let(:valid_attributes) { {api_token: "j6hd9@l664HDv2agh", start_at: "2017-04-18", price: 240.0 } }

    context 'when the record exists' do
      before { 
        patch "/rentals/1/bookings/#{booking.id}", params: valid_attributes
        booking.reload 
      }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'updates the record' do
        expect(booking.start_at).to eq("2017-04-18T00:00:00.000Z")
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /rentals/:id/bookings/:id' do
    before { delete "/rentals/1/bookings/#{booking.id}", {api_token: "j6hd9@l664HDv2agh"} }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end

end
