module ModelsStats
  class StatisticsCollector
    attr_accessor :date

    def collect(date = 1.day.ago.to_date, stat_alias = nil)
      self.date = date
      stat_params = ModelsStats::CONFIG.select{|params| name, p = params.first; name.to_s == stat_alias.to_s}
      models = if stat_params.empty?
                 ModelsStats::CONFIG
               else
                 stat_params
               end
      models.each do |config|
        name, params = config.first
        model = params["model"]
        group_by = params["group_by"]
        stat_alias = name
        group_by_values_map = params["group_by_values_map"] || ModelsStats::Statistics.default_group_by_values_map(group_by, model)
        datetime_attr = params["datetime_attr"]
        select_statement = params["select_statement"] || ModelsStats::Statistics::DEFAULT_SELECT_STATEMENT

        stat_for_model = stat_for(model, group_by, datetime_attr, params[:conditions], select_statement)

        stat_for_model = if group_by.present?
          converted_stat = convert_stat(stat_for_model, model, group_by_values_map)
          group_by_values_map.each do |index, value|
            unless converted_stat.keys.map(&:to_s).include?(value.to_s)
              converted_stat[value] = 0
            end
          end
          converted_stat
        else
          stat_key = if datetime_attr.present?
            "New"
          else
            "Total"
          end
          count = stat_for_model.to_a.first.count
          {stat_key => count.try(:round)}
        end

        ModelsStats::Statistics.write_day(stat_for_model, stat_alias, date)
      end
    end

    def convert_stat(stat_for_model, model, converter)
      p converter
      stat_hash = {}
      stat_for_model.each do |s|
        group_by_attr_value = s.attributes.values[1]
        p group_by_attr_value
        key = converter[group_by_attr_value]
        stat_hash[key] = s.count
      end
      stat_hash
    end

    private

    def stat_for(model, group_by_attribute, datetime_attr, conditions, select_statement)
      model_scope = model.to_s.constantize.unscoped.select(select_statement)
      if group_by_attribute.present?
        model_scope = model_scope.select("#{group_by_attribute}").group(group_by_attribute)
      end

      if datetime_attr.present?
        model_scope = model_scope.where(datetime_attr => date.beginning_of_day..date.end_of_day)
      end

      if conditions.present?
        model_scope = model_scope.where(conditions)
      end

      model_scope
    end
  end
end
