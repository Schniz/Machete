require('simpleplan')();

module.exports = function(express, MessageModel, UserModel) {
  var api = express();

  api.get("/", function(req, res) {
    res.send("hai");
  });

  api.get('/messages', function(req, res) {
    MessageModel.find().sort({ sentAt: -1 }).exec(function(err, messages) {
      res.json(messages);
    });
  });

  api.get('/messages/:messageId', function(req, res) {
    MessageModel.findById(req.params.messageId, function(err, message) {
      res.json(message);
    });
  });

  api.get('/messages/:messageId/mentions', function(req, res) {
    MessageModel.findById(req.params.messageId, function(err, message) {
      res.json(message.mentions());
    });
  });

  api.get('/messages/:messageId/siblings', function(req, res) {
    var messages = [];

    MessageModel.findById(req.params.messageId, function(err, mainMessage) {
      if (mainMessage == null) return res.status(404).json([]);
      var limit = parseInt(req.query.limit) || 5;

      mainMessage.siblings(limit).done(function(siblings) {
        res.json(siblings);
      });
    });
  });

  api.get("/users/:nickname/picture", function(req, res, next) {
    var nickname = req.params.nickname;
    UserModel.findOne({ nickname: nickname }, function(err, user) {
      if (err) next(err);
      if (!user && nickname !== 'joe') return res.status(404).send("not found.");

      console.warn("TODO: edit /users/:nickname/picture");

      return res.redirect("/images/" + nickname + ".jpg");
    });
  });

  return api;
}.inject();