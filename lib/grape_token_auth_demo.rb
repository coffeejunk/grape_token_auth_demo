require 'grape'
require 'grape_logging'
require 'pry'
require_relative 'grape_token_auth_setup'


class GrapeTokenAuthDemo < Grape::API
  format :json


  logger Logger.new GrapeLogging::MultiIO.new(STDOUT)
  logger.formatter = GrapeLogging::Formatters::Default.new
  use GrapeLogging::Middleware::RequestLogger, { logger: logger }
  rescue_from :all do |e|
    Rack::Response.new({ message: e.message, backtrace: e.backtrace }, 500, { 'Content-type' => 'application/json' }).finish
  end


  include GrapeTokenAuth::MountHelpers
  include GrapeTokenAuth::TokenAuthentication
  include GrapeTokenAuth::ApiHelpers

  mount_registration(to: '/auth', for: :user)
  mount_sessions(to: '/auth', for: :user)
  mount_token_validation(to: '/auth', for: :user)
  mount_confirmation(to: '/auth', for: :user)
  mount_omniauth(to: '/auth', for: :user)
  mount_password_reset(to: '/auth', for: :user)
  mount_omniauth_callbacks

  get '/demo/members_only' do
    authenticate_user!
    status 200
    present(data: { message: "Welcome #{current_user.email}",
                    user: current_user })
  end
end
