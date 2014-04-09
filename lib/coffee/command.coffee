###
# Command class
# Run pulseaudio commands
###
class Command
  # Constructor
  constructor: ->
    PulseAudio = require('pulseaudio')
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
    context = @context
    context.on 'connection', ->
      context.sink (list) ->
        console.log list
        context.end() if not callback?
    @

# exporting node module
module.exports = new Command()