Rails.application.routes.draw do
  scope '/api' do
    resources :songs, only: [:index, :show]
  end
end
