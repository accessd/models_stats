class @ModelStatisticsGraph
  constructor: (graph_title, keys, data, stat_alias, width, height) ->
    @widht = width
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

    data_graphic({
      title: @graphTitle,
      area: true,
      legend: @keys,
      legend_target: ".#{placeholder_name}_legend",
      data: @data,
      width: @width,
      height: @height,
      right: 10,
      show_years: false,
      xax_tick: 0,
      y_extended_ticks: true,
      target: "##{placeholder_name}",
      x_accessor: 'date',
      y_accessor: 'value'
    })
