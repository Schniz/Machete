module.exports = (text) ->
  text.replace(/\n+/g, '\n').split('\n').map( (line) -> line.replace(/(\s)+/g, '$1').trim() ).join('\n').trim()