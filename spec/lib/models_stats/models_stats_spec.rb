require 'spec_helper'

describe ModelsStats do
  describe "checking config for correctness" do
    it "exception if config not an array" do
      config_file = File.expand_path("../../../dummy/config/models_stats.yml",  __FILE__)
      File.open(config_file, 'w') { |file| file.write("total_users:\n\s\sstat_alias: total_users") }
      expect do
        initializer = ModelsStats::Engine.initializers.select { |i| i.name == "models_stats.load_app_root" }.first
        initializer.run(Dummy::Application)
      end.to raise_error(ModelsStats::IncorrectConfigError, "Please check config, it must be an array")
    end

    it "no exception if config is array" do
      expect do
        initializer = ModelsStats::Engine.initializers.select { |i| i.name == "models_stats.load_app_root" }.first
        initializer.run(Dummy::Application)
      end.not_to raise_error
    end
  end
end
