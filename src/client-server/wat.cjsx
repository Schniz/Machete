# @cjsx React.DOM

React = require('react')

Wat = React.createClass
  render: ->
    <div>Hey, {@props.name}</div>
  componentDidMount: ->
    console.log "WAT"

module.exports = Wat