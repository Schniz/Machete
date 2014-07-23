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

  messageSchema.methods._beforeAfter = function(isBefore, limit) {
    limit = limit || 5;
    var sentAtQuery = {};
    sentAtQuery[isBefore ? "$lte" : "$gte"] = this.sentAt;

    var query = {
      _id: { $ne: this._id },
      room: this.room,
      sentAt: sentAtQuery
    };

    var numericalIsBefore = isBefore ? -1 : 1;

    return this.collection.find(query).sort({ sentAt: numericalIsBefore }).limit(limit);
  };

  messageSchema.methods.before = function() {
    var args = [true].concat([].slice.call(arguments));
    return this._beforeAfter.apply(this, args);
  };

  messageSchema.methods.after = function() {
    var args = [true].concat([].slice.call(arguments));
    return this._beforeAfter.apply(this, args);
  };

  messageSchema.methods.siblings = function(limit) {
    limit = limit || 5; // mikol tzad
    var siblings = [];
    var collection = this.collection;
    var originalMessage = this;

    var createCollectionFromQueryCallback = function(memo, query, callback) {
      return query.toArray(function(err, messages) {
        messages.forEach(function(message) {
          return memo.push(message);
        });

        return callback(null, memo);
      });
    };

    return new Promise(function(resolve, reject) {
      async.reduce([originalMessage.before(limit), originalMessage.after(limit)], [], createCollectionFromQueryCallback, function(err, results) {
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