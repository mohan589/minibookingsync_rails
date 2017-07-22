require 'rails_helper'

RSpec.describe 'Rentals API', type: :request do
  before :each do          
    @rental = FactoryGirl.create(:rental, daily_rate: 120)
  end
  
  let!(:rental) { @rental }

  describe 'GET /rentals' do
    before { get '/rentals', {api_token: "j6hd9@l664HDv2agh"} }

    it 'returns rentals' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(1)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /rentals' do
    let(:valid_attributes)      { {api_token: "j6hd9@l664HDv2agh", name: "Villa XYZ", daily_rate: 400 } }
    let(:incomplete_attributes) { {api_token: "j6hd9@l664HDv2agh", daily_rate: 400 } }
    let(:invalid_attributes)    { {api_token: "j6hd9@l664HDv2agh", name: "Villa XYZ", daily_rate: -400.55 } }

    context 'when the request is valid' do
      before { post '/rentals', params: valid_attributes }

      it 'creates a rental' do
        expect(json['name']).to eq("Villa XYZ")
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is incomplete (not all params passed)' do
      before { post '/rentals', params: incomplete_attributes }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/can't be blank/)
      end
    end

    context 'when the request is invalid' do
      before { post '/rentals', params: invalid_attributes }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: /)
      end
    end
  end

  describe 'PUT /rentals/:id' do
    let(:valid_attributes) { { api_token: "j6hd9@l664HDv2agh", name: "ABC", daily_rate: 120 } }

    context 'when the record exists' do
      before { 
        put "/rentals/#{rental.id}", params: valid_attributes
        rental.reload  
      }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'updates the record' do
        expect(rental.name).to eq("ABC")
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'PATCH /rentals/:id' do
    let(:valid_attributes) { { api_token: "j6hd9@l664HDv2agh", name: "ABCD" } }

    context 'when the record exists' do
      before { 
        patch "/rentals/#{rental.id}", params: valid_attributes 
        rental.reload 
      }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'updates the record' do
        expect(rental.name).to eq("ABCD")
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /rentals/:id' do
    before { delete "/rentals/#{rental.id}", {api_token: "j6hd9@l664HDv2agh"} }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end

end
