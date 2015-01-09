require 'spec_helper'

describe ModelsStats::GraphHelper, type: :helper do
  describe "#render_models_stats_graph" do
    it "returns message if params doesn't exists for specific statistics" do
      expect(helper.render_models_stats_graph('total_posts')).to eq('No params for total_posts')
    end

    it "render partial with graph if stat params defined" do
      collector = ModelsStats::StatisticsCollector.new
      1.month.ago.to_date.upto(Date.yesterday) do |date|
        collector.collect(nil, date)
      end
      helper = ApplicationController.helpers
      params = {partial: 'models_stats/model_statistics_graph', locals: {graph_title: 'Total users', keys: ['new', 'ok'], stat_data: stat_data, 
                                                                         stat_alias: 'total_users', width: 1500, height: 200, graphic_lib: 'metrics_graphics', 
                                                                         graphic_type: 'stacked', date_tick: 'month', date_format: '%d/%m'}}
      expect(helper).to receive(:render).with(params)
      helper.render_models_stats_graph('total_users')
    end

    it "returns message if not known graphic type passed" do
      expect(helper.render_models_stats_graph('total_profiles')).to eq('Unknown graphic type stack')
    end
  end
end
