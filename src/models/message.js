require('simpleplan')();

module.exports = function(_, Mongoose, Promise, async, baseRequire) {
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

    var baseQuery = {
      _id: { $ne: originalMessage._id },
      room: originalMessage.room
    };

    var beforeQuery = collection.find(_.extend(baseQuery, { sentAt: { $lte: originalMessage.sentAt } })).sort({ sentAt: -1 });
    var afterQuery = collection.find(_.extend(baseQuery, { sentAt: { $gte: originalMessage.sentAt } })).sort({ sentAt: 1 });

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