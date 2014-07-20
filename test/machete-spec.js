var request = require('request');
var expect = require('chai').expect;
var lorem = require('lorem-ipsum');
var async = require('async');
require('simpleplan')();

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
    before(function(done) {
      async.times(20, function(n, next) {
        new MessageModel({
          sentAt: Date.now(),
          contents: lorem(),
          room: "main"
        }).save(function(err, data) {
          next();
        });
      }, function() {
        done();
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
        expect(JSON.parse(body).length).to.be.equal(20);
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

        message.siblings(5).done(function(siblings) {
          expect(siblings.length).to.equal(11);

          done();
        });
      });
    });
  }.inject());
});