Spree::Core::Engine.routes.draw do

  namespace :admin do
    resources :bulk_discounts do
      get 'new_break_point'
      post 'create_break_point'
    end
  end

end
