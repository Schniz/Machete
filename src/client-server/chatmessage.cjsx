# @cjsx React.DOM

React = require('react/addons')
moment = require('moment')
SetIntervalMixin = require('./set-interval-mixin.cjsx')

ChatMessageContents = React.createClass
  shouldComponentUpdate: -> no

  render: ->
    <span dir="auto" className="contents">{ @props.text }</span>

ChatMessagePermalink = React.createClass
  mixins: [
    SetIntervalMixin
  ]

  getInitialState: ->
    timeAgo: @timeAgo()
    
  timeAgo: ->
    moment(@props.sentAt).fromNow()

  updateTimeAgo: ->
    @setState timeAgo: @timeAgo()

  componentDidMount: ->
    @setInterval @updateTimeAgo, 10000

  permalinkClick: (e) ->
    e.preventDefault()
    
  render: ->
    link = "/messages/#{ @props.id }"
    if @props.isLast or @props.isActive
      <time className="time"><a href={ link } onClick={ @permalinkClick } className="permalink">{ @state.timeAgo }</a></time>
    else
      <span />

ChatMessage = React.createClass
  getInitialState: ->
    isActive: false

  setActive: ->
    @setState isActive: true

  setInactive: ->
    @setState isActive: false

  toggleActive: ->
    @setState isActive: not @state.isActive

  render: ->
    chatMessageClassName = "chatmessage"
    chatMessageClassName += " temporary" if @props.isTemporaryId
    chatMessageClassName += " highlighted" if @state.isActive

    <li className={ chatMessageClassName } onMouseLeave={ @setInactive } onDoubleClick={ @toggleActive }>
      <ChatMessageContents key="messageContents" text={ @props.contents } />
      <ChatMessagePermalink key="permalink" isActive={ @state.isActive } sentAt={ @props.sentAt } isLast={ @props.isLast } id={ @props.id } />
    </li>


module.exports = ChatMessage