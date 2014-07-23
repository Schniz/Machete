module.exports =
  componentWillMount: ->
    @intervals = []

  setInterval: (fn, ms) ->
    @intervals.push setInterval(fn, ms)

  componentWillUnmount: ->
    @intervals.forEach clearInterval