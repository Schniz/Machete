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
var io = sp.register('io', require('socket.io').listen(http, { log: true }));
require('colors');
var moment = sp.register('moment', require('moment'));
var log = sp.register('log', function() {
  var dateFormat = moment(new Date()).format("HH:mm:ss")
  var dateString = "[ ".bold.green + dateFormat.yellow + " ] log: ".bold.green;
  return console.log.bind(console, dateString).apply(console, arguments);
});
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

var getUserFromToken = function(token) {
  tokens = {
    'watwat': 'schniz'
  };

  return tokens[token];
};

io.use(function(socket, next) {
  socket.macheteData = socket.macheteData || {};
  if (!socket.request._query || !socket.request._query.accessToken) return next("no access token. please authenticate.");

  var accessToken = socket.request._query.accessToken;
  var user = getUserFromToken(accessToken);

  if (!user) return next("authentication failed.");

  socket.macheteData.user = user;
  socket.macheteData.accessToken = accessToken;

  next();
});

var sendUpdateRoomToUsers = function(room) {
  var userList = _(findClientsSocketByRoomId(room)).map(function(otherSocket) {
    return otherSocket.macheteData.user;
  }).unique().map(function(name) {
    return { name: name }
  }).value();

  io.to(room).emit('listUsers:response', {
    userList: userList,
    room: room
  });
};

var userAlreadyInRoom = function(socket, room) {
  findClientsSocketByRoomId(room).filter(function(otherSocket) {
    return otherSocket.macheteData && otherSocket.macheteData.user === socket.macheteData.user;
  })[0];
};

io.on('connection', function(socket) {
  socket.macheteData = socket.macheteData || {};

  socket.emit('welcome', {
    socketId: socket.id,
    user: socket.macheteData.user
  });

  socket.on('disconnect', function() {
    socket.rooms.forEach(function(room) {
      socket.leave(room);
      sendUpdateRoomToUsers(room);

      log(userAlreadyInRoom(socket, room));
      if (!userAlreadyInRoom(socket, room)) {
        var randomUser = uuid.v1();
        io.to(room).emit('sendMessage', {
          user: randomUser,
          _id: randomUser,
          sentAt: new Date(),
          room: room,
          contents: socket.macheteData.user + " just left the room.",
          isServerMessage: true,
          realUser: socket.macheteData.user
        });
      }
    });

    log(socket.macheteData.user + " has disconnected :( he left rooms: " + socket.rooms);
  });

  socket.on('room', function(room) {
    var socketFound = userAlreadyInRoom(socket, room.name);

    socket.join(room.name);
    var randomUser = uuid.v1();
    socket.emit('sendMessage', {
      user: randomUser,
      _id: randomUser,
      sentAt: new Date(),
      room: room,
      contents: "welcome to the room `" + room.name + "`!",
      isServerMessage: true,
      realUser: socket.macheteData.user
    });

    if (!socketFound) {
      tellRoomThatUserJoined({
        room: room.name,
        user: socket.macheteData.user
      });
      sendUpdateRoomToUsers(room.name);
    }
  });

  // socket.on('listUsers', function(listUsers) {
  //   var userList = _(findClientsSocketByRoomId(listUsers.room)).map(function(otherSocket) {
  //     return { name: otherSocket.macheteData.user };
  //   }).unique().value();

  //   socket.emit('listUsers:response', {
  //     userList: userList,
  //     room: listUsers.room
  //   });
  // });

  socket.on('sendMessage', function(message) {
    var _id = Math.floor(Math.random() * 100000);

    socket.broadcast.to(message.room).emit('sendMessage', {
      user: socket.macheteData.user,
      _id: _id,
      contents: message.contents,
      sentAt: new Date(),
      room: message.room
    });

    socket.emit('sendMessage:response', {
      tempId: message.tempId,
      newId: _id,
      ok: 'ok',
      room: message.room
    });
  });
});

tellRoomThatUserJoined = function(opts) {
  var user = opts.user;
  var room = opts.room;
  var randomUser = uuid.v1();

  io.to(room).emit('sendMessage', {
    user: randomUser,
    _id: randomUser,
    sentAt: new Date(),
    room: room,
    contents: user + " has joined the room!",
    isServerMessage: true,
    realUser: user
  });
};

function findClientsSocketByRoomId(roomId) {
  var res = []
    , room = io.sockets.adapter.rooms[roomId];
  if (room) {
      for (var id in room) {
      res.push(io.sockets.adapter.nsp.connected[id]);
      }
  }
  return res;
}

http.start = function(mongoUrl) {
  var args = [].slice.call(arguments, 1);

  Mongoose.connect(mongoUrl);
  http.listen.apply(http, args);
};

module.exports = http;