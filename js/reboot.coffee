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

    renderBarChart = (attachment, table, width = 30, margin = 5) ->
      throw 'attachment must be either bottom, top, left or right' if not (attachment in ['bottom', 'top', 'left', 'right'])

      columns = that.tableColumnsToObject table
      columnSums = sumColumns(columns)

      id = makeNewIds table

      classPart1 = if attachment in ['bottom', 'top'] then 'bar-horizontal' else 'bar-vertical'
      classPart2 = attachment

      styleContainer = ''
      styleColumn = ''
      stylePart = ''
      if attachment in ['left', 'right']
        styleContainer = "width: #{Math.max.apply(0, columnSums)}px; height: #{columns.head.length*(width+margin)}px"
        styleColumn1 = "height: #{width}px; width:"
        styleColumn2 = "top:"
        stylePart = "position: relative; display:inline-block; height: #{width}px; width:"
      else
        styleContainer = "height: #{Math.max.apply(0, columnSums)}px; width: #{columns.head.length*(width+margin)}px"
        styleColumn1 = "width: #{width}px; height:"
        styleColumn2 = "left:"
        stylePart = "width: #{width}px; height:"


      chart ="<div id=\"#{id}\" class=\"chart-#{classPart1}\" style=\"#{styleContainer}\">"
      counter = 0
      for subtable in columns.values
        chart += "<div class=\"#{classPart1}\" style=\"#{styleColumn1} #{columnSums[counter] + 10}px; #{styleColumn2} #{counter*(width+margin)}px; #{attachment}: 0px\">"

        level = 0
        endLevel = if attachment in ['bottom', 'right'] then 0 else subtable.length-1
        for value in subtable
          levelAddition = ''
          if level is endLevel
            levelAddition = '-head'

          chart += "<div class=\"#{classPart1}-part-#{classPart2}#{levelAddition}\" style=\"#{stylePart} #{value}px\"><div class=\"text\">#{value}</div></div>"
          level++

        chart += "</div>"
        counter++
      chart += "</div>"

      $(chart).insertAfter $("##{table.id}")
      $(table).addClass('hidden')

      reboot.tables++

    $('table.htable-chart-bar-horizontal:not(.rebooted)').each -> renderBarChart('bottom', this)
    $('table.htable-chart-bar-horizontal-inversed:not(.rebooted)').each -> renderBarChart('top', this)
    $('table.htable-chart-bar-vertical:not(.rebooted)').each -> renderBarChart('left', this)
    $('table.htable-chart-bar-vertical-inversed:not(.rebooted)').each -> renderBarChart('right', this)



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
