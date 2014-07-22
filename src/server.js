require('coffee-react/register');

var sp = require('simpleplan')();
var _ = sp.register('_', require('lodash'));
var Mongoose = sp.register('Mongoose', require('mongoose'));
var express = sp.register('express', require('express'));
var app = sp.register('app', express());
var async = sp.register('async', require('async'));
var Promise = sp.register('Promise', require('promise'));
var http = sp.register('http', require('http').createServer(app));
var baseRequire = sp.register('baseRequire', function(path) {
  return require(__dirname + '/' + path);
});
var baseInject = sp.register('baseInject', function(path) {
  return baseRequire(path)();
});

// Models
sp.register("MessageModel", baseInject('models/message'));

app.use("/api/v1", baseInject('controllers/api/v1'));
app.use(express.static(__dirname + "/../public/"));

app.get("/wat/:name", function(req, res) {
  var name = req.params.name;
  var Wat = require('./client-server/wat.cjsx');
  var React = require('react');

  res.send(React.renderComponentToString(Wat({ name: name })));
});

http.start = function(mongoUrl) {
  var args = [].slice.call(arguments, 1);

  Mongoose.connect(mongoUrl);
  http.listen.apply(http, args);
};

module.exports = http;