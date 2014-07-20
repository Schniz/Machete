var sp = require('simpleplan')();
var server = require('./src/server');

var host = "0.0.0.0";
var port = "3000";
var mongoUrl = 'mongodb://localhost/machete2';

server.start(mongoUrl, port, host);
console.log('server running on ' + host + ':' + port + ', using mongo: ' + mongoUrl);
