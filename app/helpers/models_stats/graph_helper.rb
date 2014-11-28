module ModelsStats::GraphHelper
  def render_models_stats_graph(stat_alias, period = 1.month)
    stat_params = ModelsStats::CONFIG.select{|config| name, params = config.first; name.to_s == stat_alias.to_s}.first
    if stat_params
      stat_params = stat_params.values[0]
      keys, stat_data = ModelsStats::Statistics.for_period(stat_alias, period)
      graph_width = stat_params["graph_width"] || ModelsStats.default_graphics_width
      graph_height = stat_params["graph_height"] || ModelsStats.default_graphics_height
      if stat_params["graphic_type"].present? && !stat_params["graphic_type"].in?(ModelsStats::GRAPHICS_TYPES)
        return "Unknown graphic type"
      end
      graphic_type = stat_params["graphic_type"] || ModelsStats.default_graphics_type
      graphic_lib = stat_params["graphic_lib"] || ModelsStats.default_lib_for_graphics
      render partial: 'models_stats/model_statistics_graph', locals: {graph_title: stat_params["description"] || stat_alias, keys: keys, stat_data: stat_data, 
                                                                      stat_alias: stat_alias, width: graph_width, height: graph_height, graphic_lib: graphic_lib, graphic_type: graphic_type}
    else
      "No params for #{stat_alias}"
    end
  end

  def render_models_stats_dashboard
    render partial: 'models_stats/dashboard'
  end
end
