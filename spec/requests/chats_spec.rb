# require 'rails_helper'

# RSpec.describe 'Chats API', type: :request do
#   # Initialize the test data
#     let!(:application) { create(:application) }
#     let!(:chats) { create_list(:chat, 3, application_id: applciation.id) }
#     let(:application_token) { applciation.applciation_token }
#     let(:chat_number) { chats.first.chat_number }

#   # Test suite for GET /chats
#   describe 'GET /applciations/[app_token]/chats' do
#     before { get "/api/v1/applications/#{application_token}/chats" }

#     context 'when application exists' do
#         it 'returns status code 200' do
#             byebug
#             expect(response).to have_http_status(200)
#         end
  
#         it 'returns all application chats' do
#             byebug
#             expect(json.size).to eq(3)
#         end
#       end
  
#       context 'when application does not exist' do
#         it 'returns status code 404' do
#             byebug
#             expect(response).to have_http_status(404)
#         end
  
#         it 'returns a not found message' do
#             byebug
#             expect(response.body).to match(/Couldn't find Todo/)
#         end
#       end
#   end

# #   # Test suite for GET /chats/:chat_number
# #   describe 'GET /applications/:application_token/chats/:chat_number' do
    
# #     context 'when the record exists' do
# #       it 'returns the chat' do
# #         application2 =  FactoryBot.create :application, name: 'app2', application_token: 'gkhjgkjhgb'
# #         chat4 = FactoryBot.create :chat, chat_number: 4, messages_count: 5
# #         get "/api/v1/applications/#{application.application_token}/chats/4"
# #         expect(json['data']).not_to be_empty
# #         expect(json['data']['chat_number']).to eq(4)
# #         expect(json['data']['messages_count']).to eq(5)
# #       end

# #       it 'returns status code 200' do
# #         application22 =  FactoryBot.create :application, name: 'app22', application_token: 'asfasfa'
# #         chat44 = FactoryBot.create :chat, chat_number: 2, messages_count: 5, app_id: application22.id 
# #         get "/api/v1/applications/#{application.application_token}/chats/4"
# #         expect(response).to have_http_status(200)
# #       end
# #     end

# #     context 'when the record does not exist' do      
# #       it 'returns status code 404' do
# #         application222 =  FactoryBot.create :application, name: 'app222', application_token: 'sdsmjhgn'
# #         chat444 = FactoryBot.create :chat, chat_number: 2, messages_count: 5, app_id: application22.id 
# #         get "/api/v1/applications/#{application.application_token}/chats/99"
# #         expect(response).to have_http_status(404)
# #       end
# #     end
# #   end

# #   # Test suite for POST /chats
# #   describe 'POST /applications/:application_token/chats/' do
    
# #     context 'when the request is valid' do
# #       before { post "/api/v1/applications/#{application.application_token}/chats", params: {} }

# #       it 'creates an application' do
# #         expect(json['data']['chat_number']).to eq(5)
# #         expect(json['data']['messages_count']).to eq(0)
# #       end

# #       it 'returns status code 201' do
# #         expect(response).to have_http_status(201)
# #       end
# #     end
# #   end
# end