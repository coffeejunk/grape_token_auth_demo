require 'mailgun'

class MailgunMailer
  def initialize(message, opts)
    @message = message
    @opts = opts
    @to_address = opts[:to] || opts['to']
  end

  def send_mail
    client.send_message ENV['MAILGUN_DOMAIN'], email
  end

  def prepare_email!
    @email = {
      to: to_address,
      from: GrapeTokenAuth.configuration.from_address,
      subject: message.subject,
      text: message.text_body,
      html: message.html_body
    }
    self
  end

  def self.send!(message, options)
    new(message, options).prepare_email!.send_mail
  end

  def valid_options?
    return false unless to_address
    true
  end

  protected

  def client
    @client ||= Mailgun::Client.new(ENV['MAILGUN_API_KEY'])
  end

  attr_reader :message, :email, :opts, :to_address
end
