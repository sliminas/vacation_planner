Rails.application.routes.draw do

  devise_for :employees, controllers: {
    sessions: 'employee/sessions'
  }, path: '/',
    path_names: {
    sign_in: 'sign_in',
    sign_out: 'sign_out'
  }

  root to: 'home#index'

  resources :employees
  resources :vacation_requests, except: %i(edit update)

end
