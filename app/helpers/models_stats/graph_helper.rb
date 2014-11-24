module ModelsStats::GraphHelper
  def render_models_stats_graph(stat_alias, period)
    stat_params = ModelsStats::CONFIG.select{|config| name, params = config.first; name.to_s == stat_alias.to_s}.first
    if stat_params
      stat_params = stat_params.values[0]
      keys, stat_data = ModelsStats::Statistics.for_period(stat_alias, period)
      graph_width = stat_params["graph_width"] || ModelsStats::DEFAULT_GRAPH_WIDTH
      graph_height = stat_params["graph_height"] || ModelsStats::DEFAULT_GRAPH_HEIGHT
      render partial: 'models_stats/model_statistics_graph', locals: {graph_title: stat_params["description"] || stat_alias, keys: keys, stat_data: stat_data, 
                                                                      stat_alias: stat_alias, width: graph_width, height: graph_height}
    else
      "No params for #{stat_alias}"
    end
  end

  def render_models_stats_dashboard
    render partial: 'models_stats/dashboard'
  end
end
