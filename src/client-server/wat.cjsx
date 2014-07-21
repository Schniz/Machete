# @cjsx React.DOM

React = require('react')

Wat = React.createClass
  render: ->
    <div>{@props.name}</div>

module.exports = Wat