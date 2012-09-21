root = window ? global

class reboot
  constructor: ->
    if not $?
      throw 'jQuery needs to be installed and required in order to get reboot to run'
      console.error 'reboot failed: jQuery not initialized'
    console.log 'rebooted'

  rebootTableBarCharts: ->

rebooter = new reboot
