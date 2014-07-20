(function() {
  var mentions = function(string) {
    return string.split(" ").map(function(word) {
      var mentionRegex = word.match(/^@([A-z_]+)/);
      if (!mentionRegex) return null;
      return mentionRegex[1];
    }).reduce(function(results, mention) {
      if (mention && results.indexOf(mention) === -1) results.push(mention);
      return results;
    }, []);
  };

  if (typeof(module) && module.exports) {
    module.exports = mentions;
  } else if (typeof(window)) {
    window.Helpers = window.Helpers || {};
    window.Helpers.mentionsFromString = mentions;
  }
})();