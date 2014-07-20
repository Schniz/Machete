// db.users.insert({ name: "Gal Schlezinger", nick: "schniz" });
require(__dirname + '/../src/server');
(function(async, Mongoose, MessageModel) {
  Mongoose.connect("mongodb://localhost/machete2");
  MessageModel.remove({}, function() {
    async.reduce(["Hai! this is me", "Hai! this is me", "WAT?", "WOW", "Howwdy my friend", "shalom olam", "mr fantastic", "shmira :(", "@schniz hagever"], 0, function(memo, text, callback) {
      new MessageModel({ sentAt: Date.now(), contents: text, sender: Mongoose.Schema.ObjectId("53cad0801b4f6ab3263c15fc"), room: "main" }).save(function() {
        setTimeout(function() {
          callback(null, memo + 1);
        }, 100);
      });
    }, function(err, result) {
      console.log("Added " + result + " messages to the db.");
      Mongoose.disconnect();
    });
  });
}.inject())();