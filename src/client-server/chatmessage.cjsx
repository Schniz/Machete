# @cjsx React.DOM

React = require('react')
moment = require('moment')
SetIntervalMixin = require('./set-interval-mixin.cjsx')

ChatMessage = React.createClass
  mixins: [
    SetIntervalMixin
  ]

  permalinkClick: (e) ->
    e.preventDefault()

  updateTimeAgo: ->
    @setState timeAgo: @timeAgo()

  getInitialState: ->
    timeAgo: @timeAgo()

  generatePermalink: ->
    link = "/messages/#{ @props.id }"
    <time className="time"><a href={ link } onClick={ @permalinkClick } className="permalink">{ @state.timeAgo }</a></time> if @props.isLast

  timeAgo: ->
    moment(@props.sentAt).fromNow()

  render: ->
    <li className="chatmessage">
      <span className="contents">{ @props.contents }</span>
      { @generatePermalink() }
    </li>

  componentDidMount: ->
    @setInterval @updateTimeAgo, 10000

module.exports = ChatMessage