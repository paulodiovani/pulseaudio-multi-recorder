(function() {
    // var client = require('./lib/js/command');
    var client = require('./lib/js/ui');

    callback = function(err, data) {
        if (err) { 
            console.error('error: ', err); 
            return;
        }

        console.log(data);
    };

    // client.list_sinks(callback);
    // client.list_sources(callback);
    // client.list_sink_inputs(callback);
    // client.start_record('alsa_output.pci-0000_00_1b.0.analog-stereo.monitor');
    client.start();
})();
