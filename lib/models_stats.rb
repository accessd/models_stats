require "redis-rails"
require "redis-objects"
require "models_stats/statistics"
require "models_stats/statistics_collector"

module ModelsStats
  mattr_accessor :redis_connection, :default_lib_for_graphics, :default_graphics_width, :default_graphics_height, :default_graphics_type,
    :default_date_tick, :default_date_format
  GRAPHICS_LIBS = [:nvd3, :metrics_graphics]
  GRAPHICS_TYPES = [:line, :stacked]

  class Engine < Rails::Engine
    initializer "models_stats.load_app_root" do |app|
      ModelsStats::CONFIG = YAML.load(ERB.new(File.read(Rails.root.join("config", "models_stats.yml").to_s)).result) rescue []
      ModelsStats.check_config
    end
  end

  self.redis_connection = Redis.current
  self.default_lib_for_graphics = :nvd3
  self.default_graphics_width = 500
  self.default_graphics_height = 120
  self.default_graphics_type = :line
  self.default_date_tick = 'day'
  self.default_date_format = '%x'

  def self.convert_hash_to_yaml(hash)
    hash.to_yaml.sub("---", '').gsub("\n", "\n\s\s\s\s\s\s")
  end

  def self.check_config
    raise IncorrectConfigError, "Please check config, it must be an array" unless CONFIG.is_a?(Array)
  end

  class IncorrectConfigError < StandardError;end
end
