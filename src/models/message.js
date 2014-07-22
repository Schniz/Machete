require('simpleplan')();

module.exports = function(Mongoose, Promise, async, baseRequire) {
  var mentionsFromString = baseRequire('client-server/mention-helper');
  
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

    var createCollectionFromQueryCallback = function(memo, query, callback) {
      return query.limit(limit).toArray(function(err, messages) {
        messages.forEach(function(message) {
          return memo.push(message);
        });

        return callback(null, memo);
      });
    };

    var beforeQuery = collection.find({ _id: { $ne: originalMessage._id }, sentAt: { $lte: originalMessage.sentAt }, room: originalMessage.room }).sort({ sentAt: -1 });
    var afterQuery = collection.find({ _id: { $ne: originalMessage._id }, sentAt: { $gte: originalMessage.sentAt }, room: originalMessage.room }).sort({ sentAt: 1 });

    return new Promise(function(resolve, reject) {
      async.reduce([beforeQuery, afterQuery], [], createCollectionFromQueryCallback, function(err, results) {
        results.push(originalMessage);
        results.sort(function(a,b) {
          return b.sentAt - a.sentAt;
        });

        resolve(results);
      });
    });
  };

  return Mongoose.model('Message', messageSchema);
}.inject();