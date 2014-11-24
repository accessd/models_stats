# ModelsStats

Graphics for your rails models. It uses [MetricsGraphics.js](https://github.com/mozilla/metrics-graphics).
Dependencies: Redis, jQuery, Bootstrap.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'models_stats', github: 'accessd/models_stats'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install models_stats

## Usage

Add config file `config/models_stats.yml`, for example:

```yaml
  ---
  - total_links_by_error_types: # Statistics alias, must to be uniq
      description: "Total links by error types"
      model: Link
      group_by: :error_type_id
      conditions: "error_type_id != <%= Link::NO_ERROR %>"
      group_by_values_map: <%= ModelsStats.convert_hash_to_yaml(Link::ERROR_NAMES) %> # for example map integer field to text represantation
      graph_width: 430
      graph_height: 140
  - average_by_keyword_positions
      description: "Average by keyword positions"
      select_statement: "AVG(google_position) AS count" # Right here you may specify select query, `count` alias for function required
      model: KeywordPosition
```

Add to your crontab rake task `models_stats:collect_statistics`, run it at 00:00 or later and it will collect statistics for yesterday.
Also you may collect statistics for specific date and config, for example:

```ruby
  date = 2.days.ago.to_date
  statistics_alias = 'total_links'
  ModelsStats::StatisticsCollector.new.collect(date, statistics_alias)
```

## Contributing

1. Fork it ( https://github.com/accessd/models_stats/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
