require 'grape'
require 'grape_token_auth'
require_relative 'grape_token_auth_setup'

class GrapeTokenAuthDemo < Grape::API
  format :json

  include GrapeTokenAuth::TokenAuthentication
  include GrapeTokenAuth::ApiHelpers

  mount_registration(to: '/auth', for: :user)
  mount_sessions(to: '/auth', for: :user)
  mount_token_validation(to: '/auth', for: :user)
  mount_confirmation(to: '/auth', for: :user)
  mount_omniauth(to: '/auth', for: :user)
  mount_password_reset(to: '/auth', for: :user)
  mount_omniauth_callbacks
end
