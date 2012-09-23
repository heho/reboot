root = window ? global

class reboot
  @tables = 0

  constructor: ->
    console.log 'rebooted'

  tableColumnsToObject: (table) ->
    columns = {head: [], values: []}
    #map each thead column to a columns.head[index]
    columns.head = $(table).find('thead th').map -> $(this).text().replace(/[\r\n]+/,'').trim()

    #map each tbody column to a columns.value[index]
    columns.values.push [] for values in columns.head
    $(table).find('tbody tr').map ->
      $(this).find('td').each (index) ->
        columns.values[index].push $(this).text().replace(/[\r\n]+/,'').trim()
    columns

  isNumber: (value) ->
    return false if undefined is value or null is value
    return true if typeof value is 'number'
    return !isNaN(value - 0)

  checkArrayOnlyContainsNumbers: (array) ->
    for value in array
      return false if not @isNumber value
    return true

  arraySum: (array) ->
    sum = 0
    sum += (value - 0) for value in array
    sum

  rebootTableBarCharts: ->
    sumColumns = (columns) ->
      sums = []
      for subarray in columns.values
        if not that.checkArrayOnlyContainsNumbers subarray
          throw 'the table body contains cells that do not contain numbers'
        sums.push that.arraySum subarray
      sums

    makeNewIds = (table) ->
      if !(table.id is "")
        return "#{table.id}-rebooted"
      else
        table.id = "table-source-chart-#{reboot.tables}"
        return "table-chart-bar-#{reboot.tables}"

    renderHorizontalBarChart = (attachment, columns, columnSums, id, width = 30, margin = 5) ->
      chart ="<div id=\"#{id}\" class=\"chart-bar-horizontal\" style=\"height: #{Math.max.apply(0, columnSums)}px; width: #{columns.head.length*(width+margin)}px\">"
      counter = 0
      for subtable in columns.values
        chart += "<div class=\"bar-horizontal\" style=\"width: #{width}px; height: #{columnSums[counter]}px; left: #{counter*(width+margin)}px; #{attachment}: 0px\">"

        level = 0
        endLevel = if attachment is 'bottom' then 0 else subtable.length-1
        for value in subtable
          levelAddition = ''
          if level is endLevel
            levelAddition = if attachment is 'bottom' then '-top' else '-bottom'

          chart += "<div class=\"bar-horizontal-part#{levelAddition}\" style=\"width: #{width}px; height: #{value}px;\"><div class=\"text\">#{value}</div></div>"
          level++

        chart += "</div>"
        counter++
      chart += "</div>"
      chart

    that = this

    $('table.htable-chart-bar-horizontal:not(.rebooted)').each ->
      columns = that.tableColumnsToObject this
      columnSums = sumColumns(columns)

      newid = makeNewIds this

      chart = renderHorizontalBarChart 'bottom', columns, columnSums, newid

      $(chart).insertAfter $("##{this.id}")
      $(this).addClass('hidden')

      reboot.tables++

    $('table.htable-chart-bar-horizontal-inversed:not(.rebooted)').each ->
      columns = that.tableColumnsToObject this
      columnSums = sumColumns(columns)

      newid = makeNewIds this

      chart = renderHorizontalBarChart 'top', columns, columnSums, newid

      $(chart).insertAfter $("##{this.id}")
      $(this).addClass('hidden')

      reboot.tables++



if not $?
  throw 'jQuery needs to be installed and required in order to get reboot to run'
  console.error 'reboot failed: jQuery not initialized'
else
  $(document).ready ->
    rebooter = new reboot

    try
      rebooter.rebootTableBarCharts()
    catch e
      console.log e
