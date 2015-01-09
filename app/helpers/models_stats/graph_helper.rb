module ModelsStats::GraphHelper
  def render_models_stats_graph(stat_alias, period = 1.month, width = nil, height = nil)
    stat_params = ModelsStats::CONFIG.select{|config| name, params = config.first; name.to_s == stat_alias.to_s}.first
    if stat_params
      stat_params = stat_params.values[0]
      keys, stat_data = ModelsStats::Statistics.for_period(stat_alias, period)
      graph_width = if width.present?
                      width
                    elsif stat_params["graph_width"].present?
                      stat_params["graph_width"]
                    else
                      ModelsStats.default_graphics_width
                    end
      graph_height = if height.present?
                       height
                     elsif stat_params["graph_height"].present?
                       stat_params["graph_height"]
                     else
                       ModelsStats.default_graphics_height
                     end
      if stat_params["graphic_type"].present? && !stat_params["graphic_type"].to_sym.in?(ModelsStats::GRAPHICS_TYPES)
        return "Unknown graphic type #{stat_params["graphic_type"]}"
      end
      graphic_type = stat_params["graphic_type"] || ModelsStats.default_graphics_type
      graphic_lib = stat_params["graphic_lib"] || ModelsStats.default_lib_for_graphics
      date_tick = stat_params["date_tick"] || ModelsStats.default_date_tick
      date_format = stat_params["date_format"] || ModelsStats.default_date_format
      render partial: 'models_stats/model_statistics_graph', locals: {graph_title: stat_params["description"] || stat_alias, keys: keys, stat_data: stat_data, 
                                                                      stat_alias: stat_alias, width: graph_width, height: graph_height, graphic_lib: graphic_lib, 
                                                                      graphic_type: graphic_type, date_tick: date_tick, date_format: date_format}
    else
      "No params for #{stat_alias}"
    end
  end

  def render_models_stats_dashboard
    render partial: 'models_stats/dashboard'
  end
end
