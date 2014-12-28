ENV['RAILS_ENV'] ||= 'test'

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'factory_girl_rails'
require 'database_cleaner'

load "#{Rails.root.to_s}/db/schema.rb" # set up memory db

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"

  config.after(:each, :type => :request) do
    Capybara.reset_sessions!    # Forget the (simulated) browser state
    Capybara.use_default_driver # Revert Capybara.current_driver to Capybara.default_driver
  end

  config.before(:suite) do
    Rails.cache.clear
    puts "Truncating database"
    DatabaseCleaner.clean_with(:truncation)

    puts "Seeding data"
    Seed.all
  end

  config.after(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end
end

def stat_data
  [[{:date=>"2014-12-01", :value=>10}, {:date=>"2014-12-03", :value=>0}, {:date=>"2014-12-15", :value=>9}], [{:date=>"2014-12-01", :value=>0}, {:date=>"2014-12-03", :value=>4}, {:date=>"2014-12-15", :value=>0}]]
end
