require('simpleplan')();

module.exports = function(Mongoose) {
  var userSchema = new Mongoose.Schema({
    name: String,
    nickname: { type: String, index: true }
  });

  var User = Mongoose.model('User', userSchema);
  return User;
}.inject();