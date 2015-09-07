require_relative 'models/user'

GrapeTokenAuth.setup! do |config|
  config.mappings = { user: User }
end
