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
  # Default stream for errors (default: process.stderr)
  ###
  err_stream: process.stderr

  ###
  # Array of child process spawned
  ###
  child_processes: []

  # Constructor
  constructor: ->

  ###
  # Set the error output stream.
  # @param {NodeStream} stream any writable stream who can receive text data
  ###
  set_error_stream: (stream) ->
    @err_stream = stream
    @

  ###
  # List active sinks
  # @param {Function} node callback function to receive the list as argument
  # @return {Command} this
  ###
  list_sinks: (callback = ->) ->
    try
      pa_context = new PulseAudio(
        client: @client_name
      )
      pa_context.on 'connection', ->
        pa_context.sink (list) ->
          callback null, list
          pa_context.end()
    catch e
      callback e.stack || e
    @

  ###
  # List active sink inputs
  # @param {Function} node callback function to receive the list as argument
  # @return {Command} this
  ###
  list_sink_inputs: (callback = ->) ->
    try
      pacmd = spawn('pacmd', ['list-sink-inputs'])
      buffer = ''

      pacmd.stdout.on 'data', (data) ->
        buffer += data.toString()
      pacmd.stdout.on 'end', ->
        callback null, buffer
    catch e
      callback e.stack || e
    @

  ###
  # List active sources
  # @param {Function} node callback function to receive the list as argument
  # @return {Command} this
  ###
  list_sources: (callback = ->) ->
    try
      pa_context = new PulseAudio(
        client: @client_name
      )
      pa_context.on 'connection', ->
        pa_context.source (list) ->
          callback null, list
          pa_context.end()
    catch e
      callback e.stack || e
    @

  ###
  # Record a source using parec and convert to ogg
  # @param {String} source_name source to record
  # @param {String} out_file filename to record to (optional)
  # @param {Function} node callback function to receive the list as argument
  # @return {Command} this
  ###
  start_record: (
    source_name,
    out_file = "record-#{new Date().getTime().toString(16)}.ogg",
    callback = ->
  ) ->
    try
      parec  = spawn('parec', ['-d', source_name, '-n', @client_name])
      oggenc = spawn('oggenc', ['-b', '192', '-o', out_file, '--raw', '-'])

      # store the child process
      @child_processes.push({process: parec})
      @child_processes.push({process: oggenc})

      parec.stdout.pipe oggenc.stdin
      parec.stderr.pipe @err_stream
      oggenc.stderr.pipe @err_stream

      parec.on 'end', callback
    catch e
      callback e.stack || e
    @

  ###
  # Lista os processos filhos em execução
  # @param {Function} node callback function to receive the list as argument
  # @return {Command} this
  ###
  list_child_process: (callback = ->) ->
    callback null, @child_processes
    @

# exporting node module
module.exports = new Command()