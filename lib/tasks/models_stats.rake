namespace :models_stats do
  desc "Collect statistics"
  task :collect_statistics => [:environment] do
    collector = ModelsStats::StatisticsCollector.new
    1.month.ago.to_date.upto(Date.yesterday) do |date|
      collector.collect
    end
  end
end
