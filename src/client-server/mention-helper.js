module.exports = function(string) {
  return string.split(" ").map(function(word) {
    var mentionRegex = word.match(/^@([A-z_]+)/);
    if (!mentionRegex) return null;
    return mentionRegex[1];
  }).reduce(function(results, mention) {
    if (mention && results.indexOf(mention) === -1) results.push(mention);
    return results;
  }, []);
};