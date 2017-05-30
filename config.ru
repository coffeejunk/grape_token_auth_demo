require 'rubygems'
require 'bundler'
Bundler.setup
require 'rack/cors'
require_relative 'config/database'
require 'warden'
require 'omniauth'
require 'omniauth-github'
require 'grape_token_auth'
require_relative 'lib/grape_token_auth_demo'

Database.new.establish_connection!

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: :any,
    expose: ['access-token', 'expiry', 'token-type', 'uid', 'client']
  end
end

use Rack::Session::Cookie, secret: 'blah'

GrapeTokenAuth.setup_warden!(self)

use OmniAuth::Builder do
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], scope: 'email,profile'
end

run GrapeTokenAuthDemo
