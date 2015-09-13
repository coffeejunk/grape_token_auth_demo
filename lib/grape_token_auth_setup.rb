require_relative 'models/user'
require_relative 'mailgun_mailer'

GrapeTokenAuth.setup! do |config|
  config.mappings = { user: User }
  config.secret = ENV['GTA_SECRET']
  config.mailer = MailgunMailer if ENV['MAILGUN_API_KEY']
  config.from_address = 'gta_demo@grape-token-auth-demo.herokuapp.com'
  config.default_url_options = { host: 'grape-token-auth-demo.herokuapp.com' }
end
