require_relative 'config/database'
require 'warden'
require 'omniauth'
require 'omniauth-github'

Database.new.establish_connection!

require_relative 'lib/grape_token_auth_demo'

use Rack::Session::Cookie, secret: 'blah'
use Warden::Manager do |manager|
  manager.failure_app = GrapeTokenAuth::UnauthorizedMiddleware
  manager.default_scope = :user
end

use OmniAuth::Builder do
  provider :github
end

run GrapeTokenAuthDemo
