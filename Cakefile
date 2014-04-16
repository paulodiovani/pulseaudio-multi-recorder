execFile = require('child_process').execFile

task 'compile', 'Compile the sources from lib/coffee to lib/js', ->
  args = ['-o', 'lib/js', '-c', 'lib/coffee']
  execFile 'coffee', args, null, (err, stdout, stderr) ->
    if err then process.stderr.write err
    else invoke 'run'

task 'run', 'Run the client.js', ->
  args = ['-e', 'node', 'client.js']
  execFile 'rxvt', args, null, (err, stdout, stderr) ->
    if err then process.stderr.write err

task 'sbuild', 'Run task from Sublime', ->
  invoke 'compile'