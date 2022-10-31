require 'sidekiq/web'
Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :applications, only: %i[create index update show], param: :application_token do
        member do
          resources :chats, only: %i[create index show], param: :chat_number do
            member do 
              resources :messages, only: %i[create index show], param: :message_number do 
                collection do
                  get '/search', to: 'messages#search'
                end
              end
            end
          end
        end 
      end
    end
  end
  mount ActionCable.server => "/cable"
  Sidekiq::Web.use(Rack::Auth::Basic) { |user, password| [user, password] == %w[admin admin] }
  mount Sidekiq::Web => '/sidekiq'
end
