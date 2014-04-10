(function() {
    var client = require('./app.js');

    client.list_sinks(console.log);
    // client.list_sources(console.log);
    // client.start_record('alsa_output.pci-0000_00_1b.0.analog-stereo.monitor');
})();
