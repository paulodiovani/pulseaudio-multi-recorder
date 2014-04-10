# Requirements
PulseAudio = require('pulseaudio')
spawn = require('child_process').spawn

###
# Command class
# Run pulseaudio commands
###
class Command

  ###
  # How to name the client on server
  ###
  client_name: 'pulseaudio-multi-recorder'

  ###
  # Pulseaudio context
  ###
  pa_context: null

  ###
  # Default stream for errors (default: process.stderr)
  ###
  err_stream: process.stderr

  # Constructor
  constructor: ->
    @pa_context = new PulseAudio(
      client: @client_name
    )

  ###
  # Set the error output stream.
  # @param {NodeStream} stream any writable stream who can receive text data
  ###
  set_error_stream: (stream) ->
    @err_stream = stream
    @

  ###
  # List active sinks
  # @param {Function} callback function to receive the list as argument
  # @return {Command} this
  ###
  list_sinks: (callback = ->) ->
    me = @
    @pa_context.on 'connection', ->
      me.pa_context.sink (list) ->
        callback list
        me.pa_context.end()
    @

  ###
  # List active sources
  # @param {Function} callback function to receive the list as argument
  # @return {Command} this
  ###
  list_sources: (callback = ->) ->
    me = @
    @pa_context.on 'connection', ->
      me.pa_context.source (list) ->
        callback list
        me.pa_context.end()
    @

  ###
  # Record a source using parec and convert to ogg
  # @param {String} source_name source to record
  # @param {String} out_file filename to record to (optional)
  # @return {Command} this
  ###
  start_record: (source_name, out_file = "record-#{new Date().getTime().toString(16)}.ogg") ->
    parec  = spawn('parec', ['-d', source_name, '-n', @client_name])
    oggenc = spawn('oggenc', ['-b', '192', '-o', out_file, '--raw', '-'])

    parec.stdout.pipe oggenc.stdin
    parec.stderr.pipe @err_stream
    oggenc.stderr.pipe @err_stream
    @

# exporting node module
module.exports = new Command()