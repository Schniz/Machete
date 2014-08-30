var _ = require('lodash');

module.exports = function(string) {
  var matcher = string.match(/\B@([A-z_]+)/g) || [];
  return _.uniq(matcher.map(function(word) {
    return word.substr(1);
  }));
};