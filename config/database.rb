require 'yaml'
require 'active_record'

class DatabaseAlreadyExists < StandardError; end

class Database
  DEFAULT_CONFIG_PATH = File.expand_path('../database.yml', __FILE__)

  attr_accessor :config_path

  def initialize
    @config_path = DEFAULT_CONFIG_PATH
    load_config_file
  end

  def establish_connection!
    params = ENV['DATABASE_URL'] ||
             ActiveRecord::Base.configurations[environment]
    ActiveRecord::Base.establish_connection(params)
  end

  def create_db
    configuration = ActiveRecord::Base.configurations[environment]
    begin
      ActiveRecord::Tasks::PostgreSQLDatabaseTasks.new(configuration).create
    rescue DatabaseAlreadyExists
      $stderr.puts "#{configuration['database']} already exists"
    end
  end

  def setup
    establish_connection!
    %i(men users).each { |table| create_resource_table(table) }
  end

  private

  def create_resource_table(name)
    connection = ActiveRecord::Base.connection
    return if connection.table_exists?(name)
    connection.create_table name.to_s, force: :cascade do |t|
      t.string 'email',                  default: '', null: false
      t.string 'image',                  default: '', null: false
      t.string 'encrypted_password',     default: '', null: false
      t.string 'reset_password_token'
      t.datetime 'reset_password_sent_at'
      t.datetime 'remember_created_at'
      t.integer 'sign_in_count',          default: 0,  null: false
      t.integer 'admin',                  default: 0,  null: false
      t.integer 'operating_thetan',       default: 0,  null: false
      t.datetime 'current_sign_in_at'
      t.datetime 'last_sign_in_at'
      t.string 'current_sign_in_ip'
      t.string 'last_sign_in_ip'
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.string 'confirmation_token'
      t.datetime 'confirmed_at'
      t.datetime 'confirmation_sent_at'
      t.string 'unconfirmed_email' # Only if using reconfirmable
      t.string 'provider',               default: '', null: false
      t.string 'uid',                    default: '', null: false
      t.string 'nickname',               default: '', null: false
      t.string 'name',                   default: '', null: false
      t.string 'favorite_color',         default: '', null: false
      t.text 'tokens'
    end
  end

  def environment
    ENV['RACK_ENV'] || 'development'
  end

  def load_config_file
    ActiveRecord::Base.configurations = YAML.load(File.read(config_path))
  end
end
