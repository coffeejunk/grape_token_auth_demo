require_relative 'config/database'

namespace :db do
  task :create do
    Database.new.create_db
  end

  task :migrate do
    Database.new.setup
  end
end
