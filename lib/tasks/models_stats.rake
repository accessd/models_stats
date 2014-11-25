namespace :models_stats do
  desc "Collect statistics for yesterday"
  task :collect_stat_for_yesterday => [:environment] do
    collector = ModelsStats::StatisticsCollector.new
    collector.collect(Date.yesterday, 'users_by_markets')
  end


  desc "Collect statistics for last month"
  task :collect_stat_for_last_month => [:environment] do
    collector = ModelsStats::StatisticsCollector.new
    1.month.ago.to_date.upto(Date.yesterday) do |date|
      collector.collect(date)
    end
  end
end
