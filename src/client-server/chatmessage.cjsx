# @cjsx React.DOM

React = require('react')
moment = require('moment')
SetIntervalMixin = require('./set-interval-mixin.cjsx')

ChatMessage = React.createClass
  mixins: [
    SetIntervalMixin
  ]
  getInitialState: ->
    timeAgo: @timeAgo()
    isActive: false

  permalinkClick: (e) ->
    e.preventDefault()

  updateTimeAgo: ->
    @setState timeAgo: @timeAgo()

  generatePermalink: ->
    link = "/messages/#{ @props.id }"
    <time className="time"><a href={ link } onClick={ @permalinkClick } className="permalink">{ @state.timeAgo }</a></time> if @props.isLast or @state.isActive

  timeAgo: ->
    moment(@props.sentAt).fromNow()

  setActive: ->
    @setState isActive: true

  setInactive: ->
    @setState isActive: false

  toggleActive: ->
    @setState isActive: not @state.isActive

  render: ->
    <li className="chatmessage" onMouseLeave={ @setInactive } onDoubleClick={ @toggleActive }>
      <span dir="auto" className="contents">{ @props.contents }</span>
      { @generatePermalink() }
    </li>

  componentDidMount: ->
    @setInterval @updateTimeAgo, 10000

module.exports = ChatMessage