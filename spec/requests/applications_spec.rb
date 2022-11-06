require 'rails_helper'

RSpec.describe 'Applications API', type: :request do
  # Initialize test data with factory bot
  let(:application4) { FactoryBot.create :application, name: 'app4', application_token: 'DFHGFJHGFH'}
  
  # Test suite for GET /applications
  describe 'GET /applications' do
    it 'returns applications' do
      # Note `json` is a custom helper to parse JSON responses
      application1 = FactoryBot.create :application, name: 'app1', application_token: 'ABCDV'
      application2 = FactoryBot.create :application, name: 'app2', application_token: 'XYZSA'
      application3 = FactoryBot.create :application, name: 'app3', application_token: 'DFZAD'
      get '/api/v1/applications' 
      expect(json['data']).not_to be_empty
      expect(json['data'].size).to eq(3)
    end

    it 'returns status code 200' do
      get '/api/v1/applications' 
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /applications/:application_token
  describe 'GET /applications/:application_token' do
    # before { get "/api/v1/applications/#{application4.application_token}" }
    
    context 'when the record exists' do
      it 'returns the application' do
        get "/api/v1/applications/#{application4.application_token}"
        expect(json['data']).not_to be_empty
        expect(json['data']['application_token']).to eq('DFHGFJHGFH')
      end

      it 'returns status code 200' do
        get "/api/v1/applications/#{application4.application_token}"
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      # let(:application_token) { "nil"}
      
      it 'returns status code 404' do
        get "/api/v1/applications/wrong_value"
        expect(response).to have_http_status(404)
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
        expect(json['data']['name']).to eq('app test')
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
        expect(json[0]['field']).to eq('name')
        expect(json[0]['message']).to eq("can't be blank")
      end
    end
  end

  # Test suite for PUT /todos/:id
  describe 'PUT /applications/:application_token' do
    let(:valid_attributes) { { name: 'edited name' } }

    context 'when the record exists' do
      before { put "/api/v1/applications/#{application4.application_token}", params: valid_attributes }

      it 'updates the record' do
        expect(json['data']['name']).to eq('edited name')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end
end