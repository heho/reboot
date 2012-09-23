root = window ? global

class reboot
  constructor: ->
    console.log 'rebooted'

  rebootTableBarCharts: ->
    $('table.table-chart-bar-horizontal').each ->
      columns = {head: [], values: []}
      #map each thead column to a columns.head[index]
      columns.head = $(this).find('thead th').map -> $(this).text().replace(/[\r\n]+/,'').trim()

      #map each tbody column to a columns.value[index]
      columns.values.push [] for values in columns.head
      $(this).find('tbody tr').map ->
        $(this).find('td').each (index) ->
          columns.values[index].push $(this).text().replace(/[\r\n]+/,'').trim()
      console.log columns



if not $?
  throw 'jQuery needs to be installed and required in order to get reboot to run'
  console.error 'reboot failed: jQuery not initialized'
else
  $(document).ready ->
    rebooter = new reboot
    rebooter.rebootTableBarCharts()
