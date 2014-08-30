# @cjsx React.DOM

React = require('react')

Mention = React.createClass
  displayName: "Mention"
  render: ->
    <span>@<u>{ @props.name }</u></span>

module.exports = Mention