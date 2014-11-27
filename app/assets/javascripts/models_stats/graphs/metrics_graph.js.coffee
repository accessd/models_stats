class @MetricsGraph
  constructor: (graph_title, keys, data, stat_alias, width, height) ->
    @width = width
    @height = height
    @graphTitle = graph_title
    @statAlias = stat_alias
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
      xax_count: 30
      xax_format: (d) =>
        df = d3.time.format('%d')
        df(d)
      target: "##{placeholder_name}"
      x_accessor: 'date'
      y_accessor: 'value'
