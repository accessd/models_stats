class @MetricsGraph
  constructor: (graph_title, keys, data, stat_alias, date_axis_tick, date_format, width, height) ->
    @width = width
    @height = height
    @graphTitle = graph_title
    @statAlias = stat_alias
    @dateAxisTick = date_axis_tick
    @dateFormat = date_format
    @keys = keys
    @data = @prepareData(data)
    if data.length
      @draw()

  prepareData: (rawData) ->
    resultData = []

    rawData.forEach (dataForKey) =>
      values = convert_dates(dataForKey, 'date')
      resultData.push values

    resultData

  draw: ->
    placeholder_name = "#{@statAlias}_statistics"
    maximums = []
    @data.forEach (data) =>
      maximum = d3.max data, (d) -> d.date
      maximums.push maximum
    maxDate = d3.max maximums

    minimums = []
    @data.forEach (data) =>
      minimum = d3.min data, (d) -> d.date
      minimums.push minimum
    minDate = d3.max minimums
    daysCount = d3.time.day.range(minDate, maxDate, 1).length
    switch @dateAxisTick
      when 'month'
        xax_count = d3.time.month.range(minDate, maxDate, 1).length
      when 'week'
        xax_count = d3.time.week.range(minDate, maxDate, 1).length
      else
        xax_count = d3.time.day.range(minDate, maxDate, 1).length

    data_graphic
      title: @graphTitle
      area: true
      legend: @keys
      legend_target: ".#{placeholder_name}_legend"
      data: @data
      width: @width
      height: @height
      bottom: 0
      top: 20
      show_years: false
      y_extended_ticks: true
      xax_count: xax_count
      xax_format: (d) =>
        df = d3.time.format(@dateFormat)
        df(d)
      target: "##{placeholder_name}"
      x_accessor: 'date'
      y_accessor: 'value'
