require "redis-rails"
require "redis-objects"
require "models_stats/statistics"
require "models_stats/statistics_collector"

module ModelsStats
  mattr_accessor :redis_connection, :default_lib_for_graphics, :default_graphics_width, :default_graphics_height, :default_graphics_type
  GRAPHICS_LIBS = [:nvd3, :metrics_graphics]
  GRAPHICS_TYPES = [:line, :stacked]

  class Engine < Rails::Engine
    initializer "models_stats.load_app_root" do |app|
      ModelsStats::CONFIG = YAML.load(ERB.new(File.read(Rails.root.join("config", "models_stats.yml").to_s)).result) rescue []
    end
  end

  self.redis_connection = Redis.current
  self.default_lib_for_graphics = :nvd3
  self.default_graphics_width = 500
  self.default_graphics_height = 120
  self.default_graphics_type = :line

  def self.convert_hash_to_yaml(hash)
    hash.to_yaml.sub("---", '').gsub("\n", "\n\s\s\s\s\s\s")
  end
end
