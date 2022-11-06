require 'rails_helper'

RSpec.describe 'Applications API', type: :request do
  # Initialize test data with factory bot
  let!(:applications) { create_list(:application, 10) }
  let(:application_token) { applications.first.application_token }

  # Test suite for GET /applications
  describe 'GET /applications' do
    # make HTTP get request before each example
    # before { get '/api/v1/applications' , headers: {'API-key': "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoiQ2hhdFN5c3RlbSIsImV4cCI6MTY5ODYxMDg4Mn0.Lv17tkZZYSZyCEkYRsNkJEgwnuj-GDhOyTE2Is_Uhi4"}}
    before { get '/api/v1/applications' }
    
    it 'returns applications' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json['data']).not_to be_empty
      expect(json['data'].size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /applications/:application_token
  describe 'GET /applications/:application_token' do
    before { get "/api/v1/applications/#{application_token}" }
    context 'when the record exists' do
      it 'returns the application' do
        byebug
        expect(json['data']).not_to be_empty
        expect(json['data']['application_token']).to eq(application_token)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:application_token) { "nil"}

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to be_empty
      end
    end
  end

  # Test suite for POST /applications
  describe 'POST /applications' do
    # valid payload
    let(:valid_attributes) { { name: 'app test' } }

    context 'when the request is valid' do
      before { post '/api/v1/applications', params: valid_attributes }

      it 'creates an application' do
        expect(json[:data][:name]).to eq('app test')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/v1/applications', params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(json[1][:field]).to eq('name')
        expect(json[1][:message]).to eq("can't be blank")
      end
    end
  end

  # Test suite for PUT /todos/:id
  describe 'PUT /applications/:application_token' do
    let(:valid_attributes) { { name: 'edited name' } }

    context 'when the record exists' do
      before { put "/api/v1/applications/#{application_token}", params: valid_attributes }

      it 'updates the record' do
        expect(json[:data]['name']).to eq('edited name')
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end
end