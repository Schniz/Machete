require('simpleplan')();

module.exports = function(Mongoose, Promise, async, baseRequire) {
  var mentionsFromString = baseRequire('helpers/mention-helper');
  
  var messageSchema = new Mongoose.Schema({
    sentAt: Date,
    contents: String,
    sender: Mongoose.Schema.ObjectId,
    room: String
  });

  messageSchema.methods.mentions = function() {
    return mentionsFromString(this.contents);
  };

  messageSchema.methods.siblings = function(limit) {
    limit = limit || 5; // mikol tzad
    var siblings = [];
    var collection = this.collection;
    var originalMessage = this;

    return new Promise(function(resolve, reject) {
      async.reduce([
        collection.find({ sentAt: { $lte: originalMessage.sentAt }, room: originalMessage.room }).sort({ sentAt: -1 }),
        collection.find({ sentAt: { $gte: originalMessage.sentAt }, room: originalMessage.room }).sort({ sentAt: 1 })
      ], [], function(memo, query, callback) {
        query.limit(limit).toArray(function(err, messages) {
          messages.forEach(function(message) {
            if (message._id !== originalMessage._id) memo.push(message);
          });

          callback(null, memo);
        });
      }, function(err, results) {
        results.push(originalMessage);
        results.sort(function(a,b) {
          return b.sentAt - a.sentAt;
        });

        resolve(results);
      });
    })
  };

  return Mongoose.model('Message', messageSchema);
}.inject();