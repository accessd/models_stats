require 'spec_helper'

describe ModelsStats do
  describe "checking config for correctness" do
    it "exception if config not an array" do
      config_file = File.expand_path("../../../dummy/config/models_stats.yml",  __FILE__)
      File.open(config_file, 'w') { |file| file.write("total_users:\n\s\sstat_alias: total_users") }
      expect do
        run_initializer
      end.to raise_error(ModelsStats::IncorrectConfigError, "Please check config, it must be an array")
      original_config_file = File.expand_path("../../../dummy/config/models_stats_original.yml",  __FILE__)
      FileUtils.cp(original_config_file, config_file)
      run_initializer
    end

    it "no exception if config is array" do
      expect do
        run_initializer
      end.not_to raise_error
    end
  end

  begin "Helpers"
    def run_initializer
      initializer = ModelsStats::Engine.initializers.select { |i| i.name == "models_stats.load_app_root" }.first
      initializer.run(Dummy::Application)
    end
  end
end
