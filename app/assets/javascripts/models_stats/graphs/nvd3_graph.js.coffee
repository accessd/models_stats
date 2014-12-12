class @Nvd3Graph
  constructor: (data, keys, stat_alias, graph_type, date_axis_tick, date_format, width, height) ->
    @statAlias = stat_alias
    @width = width
    @height = height
    @keys = keys
    @graphType = graph_type
    @dateAxisTick = date_axis_tick
    @dateFormat = date_format
    @data = @prepareData(data)
    @draw()

  prepareData: (rawData) ->
    resultData = []

    i = 0
    rawData.forEach (dataForKey) =>
      values = []
      dataForKey.forEach (stat) =>
        fff = d3.time.format('%Y-%m-%d')
        date = fff.parse(stat.date)
        values.push [date, stat.value]

      resultData.push {values: values, key: keys[i]}
      i++

    resultData

  draw: ->
    placeholder_name = "#{@statAlias}_statistics"
    graphData = @data
    dateFormat = @dateFormat
    graphType = @graphType

    if graphData.length
      maximums = []
      graphData.forEach (data) =>
        maximum = d3.max data.values, (d) -> d[1]
        maximums.push maximum
      maxY = d3.max maximums

      maximums = []
      graphData.forEach (data) =>
        maximum = d3.max data.values, (d) -> d[0]
        maximums.push maximum
      maxDate = d3.max maximums

      minimums = []
      graphData.forEach (data) =>
        minimum = d3.min data.values, (d) -> d[0]
        minimums.push minimum
      minDate = d3.max minimums

      nv.addGraph =>
        if graphType == 'stacked'
          chart = nv.models.stackedAreaChart().x((d) -> d[0]).y((d) -> d[1]).useInteractiveGuideline(true)
            .transitionDuration(500)
            .showControls(true)
            .clipEdge(true)
            .color(d3.scale.category20().range())
        else
          chart = nv.models.lineChart().interpolate("basic").x((d) ->
            d[0]
          ).y((d) ->
            d[1]
          ).color(d3.scale.category20().range())
        chart.width = @width
        chart.height = @height

        chart.yAxis.tickFormat(d3.format('f'))

        chart.forceY([0, maxY])
        chart.yDomain([0.001, maxY])

        chart.xAxis.tickFormat (d) ->
          d3.time.format(dateFormat) new Date(d)

        switch @dateAxisTick
          when 'month'
            chart.xAxis.tickValues(d3.time.month.range(minDate, maxDate, 1))
          when 'week'
            chart.xAxis.tickValues(d3.time.week.range(minDate, maxDate, 1))
          else
            chart.xAxis.tickValues(d3.time.day.range(minDate, maxDate, 1))
        d3.select("##{placeholder_name} svg").datum(graphData).transition().duration(500).call(chart)

        nv.utils.windowResize chart.update
        chart
