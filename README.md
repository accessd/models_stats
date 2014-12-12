# ModelsStats

Graphics for your rails models. It may show count(or average, or sum, or another sql agregate function) of models for each day with grouping, conditions.

For graphics it uses for your choice [MetricsGraphics.js](https://github.com/mozilla/metrics-graphics) or/and [NVD3](http://nvd3.org/).

Dependencies: [Redis](http://redis.io/) for store statistics.
[D3](http://d3js.org/), [jQuery](http://jquery.com/), [Bootstrap](http://getbootstrap.com/) it's dependencies of MetricsGraphics.js.

Preview:

NVD3:

![ScreenShot](https://raw.github.com/accessd/models_stats/master/doc/img/nvd3_example.png)

![ScreenShot](https://raw.github.com/accessd/models_stats/master/doc/img/nvd3_users_example.png)

MetricsGraphics.js

![ScreenShot](https://raw.github.com/accessd/models_stats/master/doc/img/mg_example.png)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'models_stats', github: 'accessd/models_stats'
```

And then execute:

    $ bundle

In your application.js manifest:

    //= require models_stats/nvd3

or/and

    //= require models_stats/metrics_graphics

if you want use MetricsGraphics.

In your application.css.scss manifest:

    //= require models_stats/nvd3

or/and

    //= require models_stats/metrics_graphics

if you want use MetricsGraphics.

Also if you use MetricsGraphics.js you must have [jQuery](http://jquery.com/) and [Bootstrap](http://getbootstrap.com/) js/css included.


## Usage

### Configuration

Add config file `config/models_stats.yml`, for example:

minimal configuration:

```yaml
  ---
  - total_users:
      description: "Total users"
      model: User
```

it would be calculate total users for day.

Enhanced configuration:

```yaml
  ---
  - total_links_by_error_types: # Statistics alias, must be uniq
      description: "Total links by error types"
      model: Link
      datetime_attr: :created_at # Date or datetime attribute, allows to calculate the count of models per day
      group_by: :error_type_id
      conditions: "error_type_id != <%= Link::NO_ERROR %>"
      group_by_values_map: <%= ModelsStats.convert_hash_to_yaml(Link::ERROR_NAMES) %> # for example maping integer field to text representation
      graph_width: 430
      graph_height: 140
      graphic_lib: nvd3 # By default, or can be metrics_graphics
      graphic_type: stacked # It's can be using with nvd3, by default line
      date_tick: day # By default, or can be month or week
      date_format: '%d/%m' # By default is %x, more information about formattting time available at https://github.com/mbostock/d3/wiki/Time-Formatting
  - average_by_keyword_positions:
      description: "Average by keyword positions"
      select_statement: "AVG(google_position) AS count" # Right here you may specify select query, `count` alias for function required
      model: KeywordPosition
```

If you want using specific redis for store statistics, set it in `config/initializers/models_stats.rb`, for example:

    ModelsStats.redis_connection = Redis.new(host: '127.0.0.1', port: 6379, db: 5)

Default graphics library can be configured through:

    ModelsStats.default_lib_for_graphics = :nvd3 # Or metrics_graphics

Default graphics type:

    ModelsStats.default_graphics_type = :line # Or stacked

Default graph width:

    ModelsStats.default_graphics_width = 500

Default graph height:

    ModelsStats.default_graphics_height = 120

Default date tick:

    ModelsStats.default_date_tick = :day # Or month, week

Default date format:

    ModelsStats.default_date_format = '%d/%m'

For the full list of directives for formatting time, refer to [this list](https://github.com/mbostock/d3/wiki/Time-Formatting)

### Collecting statistics

Add to your crontab(may use [whenever](https://github.com/javan/whenever)) rake task `models_stats:collect_stat_for_yesterday`, run it at 00:00 or later and it will collect statistics for yesterday.
For collecting statistics for last month run rake task `models_stats:collect_stat_for_last_month`.
Also you may collect statistics for specific date and config, for example:

```ruby
  date = 2.days.ago.to_date
  statistics_alias = 'total_links_by_error_types' # statistic alias which you define in `config/models_stats.yml`
  ModelsStats::StatisticsCollector.new.collect(statistics_alias, date) # By default date is yestarday
```

### Display graphics

In your views use helpers:

Render single graphic for total_links_by_error_types statistic alias(which you define in `config/models_stats.yml`) and last week

    = render_models_stats_graph('total_links_by_error_types', 1.week) # By default period is 1.month

Render all defined graphics splited by two columns - first for new models count, second for total models count

    = render_models_stats_dashboard

## Contributing

1. Fork it ( https://github.com/accessd/models_stats/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
