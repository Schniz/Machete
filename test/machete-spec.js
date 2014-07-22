var request = require('request');
var expect = require('chai').expect;
var lorem = require('lorem-ipsum');
var async = require('async');
require('simpleplan')();
var mentionHelper = require('../src/client-server/mention-helper');

describe("Machete API", function() {
  var server = require('../src/server');
  var port = process.env.PORT || 8088;

  before(function(done) {
    var mongoUrl = 'mongodb://localhost/machete_testspec_' + new Date().getTime();
    server.start(mongoUrl, port, 'localhost', function() {
      done();
    });
  });

  after(function(done) {
    server.close(function() {
      // Drops the temporary db
      (function(Mongoose) {
        Mongoose.connection.db.dropDatabase();
      }.inject())();

      done();
    });
  });

  describe("Messages", function(MessageModel) {
    var numberOfMessagesCreated = 0;

    before(function(done) {
      async.times(20, function(n, next) {
        new MessageModel({
          sentAt: Date.now(),
          contents: lorem(),
          room: "main"
        }).save(function(err, data) {
          numberOfMessagesCreated++;
          next();
        });
      }, function() {
        new MessageModel({
          sentAt: Date.now(),
          contents: lorem() + " @schniz, ya gever!!!",
          room: "main"
        }).save(function(err, lastMessage) {
          mentionMessageId = lastMessage._id;
          numberOfMessagesCreated++;
          done();
        });
      });
    });

    after(function(done) {
      MessageModel.remove({}, function(err) {
        done();
      });
    });

    it("should give a list of messages", function(done) {
      request("http://localhost:" + port + "/api/v1/messages/", function(err, res, body) {
        expect(res.statusCode).to.be.equal(200);
        expect(JSON.parse(body).length).to.be.equal(numberOfMessagesCreated);
        done();
      });
    });

    it("should get a message", function(done) {
      MessageModel.findOne(function(err, message) { 
        request("http://localhost:" + port + "/api/v1/messages/" + message._id, function(err, res, body) {
          expect(res.statusCode).to.be.equal(200);
          expect(body).to.deep.equal(JSON.stringify(message));

          done();
        });
      });
    });

    it("should get the message siblings via Mongoose", function(done) {
      MessageModel.find(function(err, messages) {
        var messageIndex = Math.round(messages.length / 2);
        var message = messages[messageIndex];
        var numberOfSiblingsToFetch = [1, 2, 3, 4, 5, 6];

        async.map(numberOfSiblingsToFetch, function(count, callback) {
          message.siblings(count).done(function(siblings) {
            expect(siblings).to.be.an('array');
            callback(null, { count: count, result: siblings.length });
          });
        }, function(err, results) {
          results.forEach(function(result) {
            expect(result.result).to.be.equal(result.count * 2 + 1);
          });

          done();
        });
      });
    });

    it("should get a list of mentions from string", function() {
      expect(mentionHelper("hello world")).to.deep.equal([]);
      expect(mentionHelper("what is up @schniz")).to.deep.equal(['schniz']);
      expect(mentionHelper("@schniz@schniz")).to.deep.equal(['schniz']);
      expect(mentionHelper("@schniz @schniz")).to.deep.equal(['schniz']);
      expect(mentionHelper("@schniz!")).to.deep.equal(['schniz']);
      expect(mentionHelper("hello world@schniz")).to.deep.equal([]);
    });

    it("should get the list of the mentions from the message contents", function(done) {
      MessageModel.find(function(err, messages) {
        messages.forEach(function(message) {
          expect(message.mentions()).to.deep.equal(mentionHelper(message.contents));
        });

        done();
      });
    });
  }.inject());
});