Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :applications, only: %i[create index update show], param: :application_token do
        member do
          resources :chats, only: %i[create index show], param: :chat_number do
            member do 
              resources :messages, only: %i[create index show], param: :message_number
            end
          end
        end 
      end
    end
  end 
  match '/api/v1/applications/:application_token/chats/:chat_number/search/:search_content' , :to => 'api/v1/messages#search' , :via => [:get]
end
