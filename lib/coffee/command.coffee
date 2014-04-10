PulseAudio = require('pulseaudio')

###
# Command class
# Run pulseaudio commands
###
class Command
  # Constructor
  constructor: ->
    @context = new PulseAudio(
      client: 'pulseaudio-multi-recorder'
    )

  ###
  # List the active sinks
  # @param callback function to execute after the method finish,
  #   receive the context as argument.
  #   If no callback is provided, end the context.
  ###
  list_sinks: (callback) ->
    me = @
    @context.on 'connection', ->
      me.context.sink(me._onlist.bind me, callback)
    @

  list_sources: (callback) ->
    me = @
    @context.on 'connection', ->
      me.context.source(me._onlist.bind me, callback)
    @

  _onlist: (callback, list) ->
    console.log list
    if typeof callback is 'function' then callback.call(@context)
    else if not callback? then @context.end()

# exporting node module
module.exports = new Command()