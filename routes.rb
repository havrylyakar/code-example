.......................


namespace :api, defaults: { format: :json_api }, constraints: { host: Rails.application.secrets.app_host_name } do
  namespace :v1 do
    resources :applications
    resources :users

    resources :users_sending_emails, path: '/users-sending-emails' do
      member do
        post 'send-confirmation', to: 'users_sending_emails#send_confirmation', as: 'send_confirmation'
      end
    end


    .................



  end
end
