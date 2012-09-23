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
    that = this
    $('table.table-chart-bar-horizontal:not(.rebooted)').each ->
      columns = that.tableColumnsToObject this
      columnSums = []
      for subarray in columns.values
        if not that.checkArrayOnlyContainsNumbers subarray
          throw 'the table body contains cells that do not contain numbers'
        columnSums.push that.arraySum subarray

      console.log columnSums

      if !(this.id is "")
        newid = "#{this.id}-rebooted"
      else
        this.id = "table-source-chart-#{reboot.tables}"
        newid = "table-chart-bar-#{reboot.tables}"

      width = 30
      margin = 5

      chart = "<div id=\"#{newid}\" class=\"chart-bar-horizontal\" style=\"height: #{Math.max.apply(0, columnSums)}px; width: #{columns.head.length*(width+margin)}px\">"
      counter = 0
      for subtables in columns.values
        chart += "<div class=\"bar-horizontal\" style=\"width: #{width}px; height: #{columnSums[counter]}px; left: #{counter*(width+margin)}px; bottom: 0px\">"

        level = 0
        for value in subtables
          levelAddition = ''
          levelAddition = '-top' if level is 0
          chart += "<div class=\"bar-horizontal-part#{levelAddition}\" style=\"width: #{width}px; height: #{value}px;\"></div>"
          level++

        chart += "</div>"
        counter++
      chart += "</div>"

      $(chart).insertAfter $("##{this.id}")

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
