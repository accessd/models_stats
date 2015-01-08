module ModelsStats
  class Statistics
    DEFAULT_SELECT_STATEMENT = "COUNT(id) AS count"

    def self.default_group_by_values_map(group_by, model)
      model_klass = model.to_s.constantize
      if model_klass.respond_to?(:state_machine)
        state_machine_states = model_klass.state_machine.states
        state_machine_defined = !state_machine_states.first.name.nil?

        if state_machine_defined #&& value_numeric?(group_by)
          Hash[model.to_s.constantize.state_machine.states.map{|state| [state.value, state.name]}]
        else
          {}
        end
      else
        {}
      end
    end

    def self.value_numeric?(value)
      !value.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/).nil?
    end

    def self.for_period(stat_name, period = 1.month)
      model_statistics = []

      period.ago.to_date.upto(Date.yesterday) do |date|
        stat = read(stat_name, date)
        next if stat.empty?

        model_statistics << [date, stat]
      end

      all_keys = []
      stat = []

      model_statistics.each do |stat|
        stat[1].each do |key, count|
          models_count = count.to_i
          if models_count > 0
            all_keys << key unless all_keys.include?(key)
          end
        end
      end

      all_keys.each do |key|
        values = []
        model_statistics.each do |stat|
          date = stat[0]
          stat[1].each do |k, count|
            if k == key
              values << {date: date.to_s, value: count.to_i}
            end
          end
        end

        stat << values
      end

      return all_keys, stat
    end

    def self.write_day(stat, stat_alias, date)
      full_key = full_key(stat_alias, date)
      hash = Redis::HashKey.new(full_key, self.redis_connection)
      hash.bulk_set(stat)
    end

    def self.full_key_matched(stat_alias)
      "#{key_prefix}:#{stat_alias}:*"
    end

    private

    def self.read(stat_alias, date)
      full_key = full_key(stat_alias, date)
      hash = Redis::HashKey.new(full_key, self.redis_connection)
      hash.all
    end

    def self.key_prefix
      app_name = Rails.application.class.to_s.split("::").first
      "statistics:#{app_name}:models"
    end

    def self.full_key(stat_alias, date)
      "#{key_prefix}:#{stat_alias}:#{date}"
    end

    def self.redis_connection
      @@redis_conn ||= ModelsStats.redis_connection
    end
  end
end
