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
    server.start('mongodb://localhost/machete2testspec', port, 'localhost', function() {
      done();
    });
  });

  after(function(done) {
    server.close(function() {
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

        message.siblings(1).done(function(siblings) {
          expect(siblings.length).to.equal(3);

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