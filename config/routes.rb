Rails.application.routes.draw do
  namespace :admin do
  end

  namespace :front do
  end

  root to: 'front/site#index'
end
