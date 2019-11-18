Rails.application.routes.draw do
  root to: 'rooms#index'

  resources :rooms, except: %i[destroy edit], param: :token do
    post :show, on: :member # POST запрос на странице проверки пароля для входа в приватную комнату
  end
  mount ActionCable.server => '/cable'
  mount ResqueWeb::Engine => '/resque_web'
end
