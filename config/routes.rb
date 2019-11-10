Rails.application.routes.draw do
  root to: 'rooms#index'

  resources :rooms, only: %i[create index show new], param: :token do
    post :show, on: :member # POST запрос на странице проверки пароля для входа в приватную комнату
  end
  mount ActionCable.server => '/cable'
end
