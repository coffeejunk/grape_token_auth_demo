require 'rubygems'
require 'bundler'
Bundler.setup
require 'rack/cors'
require_relative 'config/database'
require 'warden'
require 'omniauth'
require 'omniauth-github'

Database.new.establish_connection!

require_relative 'lib/grape_token_auth_demo'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: :any,
    expose: ['access-token', 'expiry', 'token-type', 'uid', 'client']
  end
end

use Rack::Session::Cookie, secret: 'blah'
use Warden::Manager do |manager|
  manager.failure_app = GrapeTokenAuth::UnauthorizedMiddleware
  manager.default_scope = :user
end

use OmniAuth::Builder do
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], scope: 'email,profile'
end

run GrapeTokenAuthDemo
