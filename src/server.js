require('coffee-react/register');

var sp = require('simpleplan')();
var uuid = require('node-uuid');
var _ = sp.register('_', require('lodash'));
var Mongoose = sp.register('Mongoose', require('mongoose'));
var express = sp.register('express', require('express'));
var app = sp.register('app', express());
var async = sp.register('async', require('async'));
var Promise = sp.register('Promise', require('promise'));
var http = sp.register('http', require('http').createServer(app));
var io = sp.register('io', require('socket.io').listen(http));
var baseRequire = sp.register('baseRequire', function baseRequire(path) {
  return require(__dirname + '/' + path);
});
var baseInject = sp.register('baseInject', function baseInject(path) {
  return baseRequire(path)();
});

// Models
sp.register("UserModel", baseInject('models/user'));
sp.register("MessageModel", baseInject('models/message'));

app.use("/api/v1", baseInject('controllers/api/v1'));
app.use(express.static(__dirname + "/../public/"));

io.on('connection', function(socket) {
  socket.on('room', function(room) {
    console.log(room);
    socket.join(room.room);
    console.log(socket.rooms);
  });

  socket.on('sendMessage', function(message) {
    console.log(message);
    var _id = Math.floor(Math.random() * 100000);

    socket.broadcast.to(message.room).emit('sendMessage', {
      user: "schniz",
      _id: _id,
      contents: message.contents,
      sentAt: new Date()
    });

    socket.emit('sendMessage:result', {
      tempId: message.tempId,
      newId: _id,
      ok: 'ok',
      room: message.room
    });
  });
});

http.start = function(mongoUrl) {
  var args = [].slice.call(arguments, 1);

  Mongoose.connect(mongoUrl);
  http.listen.apply(http, args);
};

module.exports = http;