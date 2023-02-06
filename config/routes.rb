Rails.application.routes.draw do
  devise_for :administrators, :controllers =>{
    :registrations => 'administrators/registrations',
    :sessions => 'administrators/sessions'
  }
  devise_scope :administrator do
    get "sign_in", :to => "administrators/sessions#new"
    get "sign_out", :to => "administrators/sessions#destroy"
  end

  get 'reserves/index'
  devise_for :oaccounts, :controllers =>{
    :registrations => 'oaccounts/registrations',
    :sessions => 'oaccounts/sessions'
  }
  devise_scope :oaccount do
    get "osign_in", :to => "oaccounts/sessions#new"
    get "osign_out", :to => "oaccounts/sessions#destroy"
  end
  namespace :oaccounts do
    resources :notices, only: [:index, :destroy]
  end

  devise_for :uaccounts, :controllers => {
    :registrations => 'uaccounts/registrations',
    :sessions => 'uaccounts/sessions'
  }
  devise_scope :uacoount do
    get "usign_in", :to => "uaccounts/sessions#new"
    get "usign_out", :to => "uaccounts/sessions#destroy"
  end

  namespace :uaccounts do
    resources :notices, only: [:index, :destroy]
  end
# usersメニュー　routing
  resources :users do
    member do
      post "confirm"
    end
  end
  # officesメニュー　routing
  resources :offices do
    member do
      post "confirm"
      post "find"
      get "bed_article"
      get "bed_article_edit"
      post "bed_article_confirm"
      post "bed_article_update"
    end
  end

  # reserves　メニューrouting
  resources :reserves do
    resources :comments, only: [:create, :destroy, :update]
    member do
      get "index"
      get "bed_show"
      get "reserve_show"
      get "comment_index"
      get "notice_index"
      post "delete_confirm"
      post "delete"
      post "edit"
      post "edit_confirm"
      post "edit_update"
    end
    collection do
      resources :favorites, only: [:create, :index] do
        collection do
          delete "destroy", as: :destroy
        end
      end
      get "service_date"
      get "permit_index"
      get "decline_index"
      get "history_index"
      get "favorite_index"
      get "info_type"
      post "confirm"
    end
  end
  resources :matters do
    member do
      post "edit_confirm"
      post "edit"
      post "destroy_confirm"
    end
    collection do
      post "confirm"
    end
  end
  resources :reserve_selves do
    resources :comments, only: [:create, :destroy, :update]
    member do
      get "decline_index"
      get "permit_index"
      get "history_index"
      get "comment_index"
      get "matter_index"
      get "matter_show"
      get "index"
      get "service_date"
      get "reserve_show"
      get "month_total"
      get "notice_index"
      post "permit_confirm"
      post "permit"
      post "decline_confirm"
      post "decline"
      post "decline_cancel_confirm"
      post "decline_cancel"
      post "cancel_confirm"
      post "cancel"
      post "edit"
      post "edit_confirm"
      post "edit_update"
    end
    collection do
      post "confirm"
    end
  end
  # mainメニュー　routing
  get "/", to:  "main#index", as: :root

  resources :main do
    member do
      get "show"
    end
    collection do
      get "index"
      get "info_type"
      get "contact"
      get "faq"
      get "privacy_policy"
      get "map"
      post "contact_confirm"
      post "send_contact"
    end
  end
  namespace :admin do
    resources :home, only: [:index] do

    end
    resources :prefectures do
      member do
        post "confirm_delete"
      end
    end
  end
  #adminメニュー
  resources :admin do
    member do
      post "confirm_delete_city"
      get "edit_city"
      post "update_city"
      post "delete_city"
      get "edit_office"
      post "confirm_office"
      post "update_office"
      post "delete_office_confirm"
      post "delete_office"
      get "edit_bedtype"
      post "update_bedtype"
      post "delete_bedtype"
      post "confirm_delete_bedtype"
      post "delete_uaccount_confirm"
      post "delete_uaccount"
      get "reserve_show"
    end
    collection do
      get "new_city"
      post "new_city_update"
      get "city_index"
      get "info_delete"
      get "new_bedtype"
      post "new_bedtype_update"
      get "bedtype_index"
      get "uaccount_index"
      get "mail_all_send"
      post "mail_all_send_confirm"
      post "all_uaccounts_send"
      get "reserves_index"
    end
  end
end
