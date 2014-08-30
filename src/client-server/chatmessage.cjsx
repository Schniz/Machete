# @cjsx React.DOM

React = require('react/addons')
moment = require('moment')
gemoji = require('gemoji')
SetIntervalMixin = require('./set-interval-mixin.cjsx')
lineTrimmerHelper = require('./line-trimmer-helper.cjsx')
EmojiPicture = require('./emoji-picture.cjsx')

ChatMessageContents = React.createClass
  displayName: "ChatMessageContents"

  statics:
    emojiRegex: (->
      new RegExp("(:(?:#{Object.keys(gemoji.name).join('|')}):)", "g")
    )()

  shouldComponentUpdate: -> no

  renderEmoji: (text) ->
    splittedText = text.split(ChatMessageContents.emojiRegex)
    emojis = splittedText.map (word, index) ->
      if not ChatMessageContents.emojiRegex.test(word)
        <span key={ "text-#{index}" }>{ word }</span>
      else
        <EmojiPicture key={ "emoji-#{index}" } name={ word.match(/:(.+):/)[1] } />

  renderText: ->
    text = lineTrimmerHelper(@props.text)
    text = @renderEmoji(text)

  render: ->
    <span dir="auto" ref="text" className="contents">{ @renderText() }</span>

ChatMessagePermalink = React.createClass
  displayName: "ChatMessagePermalink"
  
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
  displayName: "ChatMessage"
  
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
    chatMessageClassName += " server-message" if @props.isServerMessage

    <li className={ chatMessageClassName } onMouseLeave={ @setInactive } onDoubleClick={ @toggleActive }>
      <ChatMessageContents key="messageContents" text={ @props.contents } />
      <ChatMessagePermalink key="permalink" isActive={ @state.isActive } sentAt={ @props.sentAt } isLast={ @props.isLast } id={ @props.id } />
    </li>


module.exports = ChatMessage