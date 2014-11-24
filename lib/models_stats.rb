require "redis-rails"
require "redis-objects"
require "models_stats/statistics"
require "models_stats/statistics_collector"

module ModelsStats
  mattr_accessor :redis_connection
  DEFAULT_GRAPH_WIDTH = 375
  DEFAULT_GRAPH_HEIGHT = 180

  class Engine < Rails::Engine
    initializer "models_stats.load_app_root" do |app|
      ModelsStats::CONFIG = YAML.load(ERB.new(File.read(Rails.root.join("config", "models_stats.yml").to_s)).result)
    end
  end

  self.redis_connection = Redis.current

  def self.convert_hash_to_yaml(hash)
    hash.to_yaml.sub("---", '').gsub("\n", "\n\s\s\s\s\s\s")
  end
end
