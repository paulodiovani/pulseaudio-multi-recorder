(function() {
    var client = require('./app.js');

    client.list_sinks(true).list_sources();
})();