# ModelsStats

Graphics for your rails models. It uses [MetricsGraphics.js](https://github.com/mozilla/metrics-graphics).
Dependencies: [Redis](http://redis.io/) for store statistics; [D3](http://d3js.org/), [jQuery](http://jquery.com/), [Bootstrap](http://getbootstrap.com/) it's dependencies of MetricsGraphics.js.

Preview:

![ScreenShot](https://raw.github.com/accessd/models_stats/master/doc/img/stat_example.png)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'models_stats', github: 'accessd/models_stats'
```

And then execute:

    $ bundle

In your application.js manifest:

    //= require models_stats/models_stats

In your application.css.scss manifest:

    //= require models_stats/models_stats

Also you must have [jQuery](http://jquery.com/) and [Bootstrap](http://getbootstrap.com/) js/css included.


## Usage

### Configuration

Add config file `config/models_stats.yml`, for example:

```yaml
  ---
  - total_links_by_error_types: # Statistics alias, must be uniq
      description: "Total links by error types"
      model: Link
      group_by: :error_type_id
      conditions: "error_type_id != <%= Link::NO_ERROR %>"
      group_by_values_map: <%= ModelsStats.convert_hash_to_yaml(Link::ERROR_NAMES) %> # for example map integer field to text represantation
      graph_width: 430
      graph_height: 140
  - average_by_keyword_positions:
      description: "Average by keyword positions"
      select_statement: "AVG(google_position) AS count" # Right here you may specify select query, `count` alias for function required
      model: KeywordPosition
```

If you want using specific redis for store statistics, set it in `config/initializers/models_stats.rb`, for example:

    ModelsStats.redis_connection = Redis.new(host: '127.0.0.1', port: 6379, db: 5)

### Collecting statistics

Add to your crontab(may use [whenever](https://github.com/javan/whenever)) rake task `models_stats:collect_stat_for_yesterday`, run it at 00:00 or later and it will collect statistics for yesterday.
For collecting statistics for last month run rake task `models_stats:collect_stat_for_last_month`.
Also you may collect statistics for specific date and config, for example:

```ruby
  date = 2.days.ago.to_date
  statistics_alias = 'total_links'
  ModelsStats::StatisticsCollector.new.collect(statistics_alias, date)
```

### Display graphics

In your views use helpers:

Render single graphic for total_links stat and last month

    = render_models_stats_graph('total_links', 1.month)

Render all defined graphics splited by two columns - first for new models count, second for total models count

    = render_models_stats_dashboard

## Contributing

1. Fork it ( https://github.com/accessd/models_stats/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
