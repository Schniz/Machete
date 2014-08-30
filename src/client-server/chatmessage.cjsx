# @cjsx React.DOM

React = require('react/addons')
moment = require('moment')
gemoji = require('gemoji')
_s = require('underscore.string')
SetIntervalMixin = require('./set-interval-mixin.cjsx')
lineTrimmerHelper = require('./line-trimmer-helper.cjsx')
EmojiPicture = require('./emoji-picture.cjsx')
Mention = require('./mention.cjsx')
mentionsHelper = require('./mention-helper.js')

ChatMessageContents = React.createClass
  displayName: "ChatMessageContents"

  statics:
    emojiRegex: (->
      new RegExp("(:(?:#{Object.keys(gemoji.name).join('|')}):)", "g")
    )()
    mentionRegex: /\B(@[A-z_-]+)/g

  shouldComponentUpdate: -> no

  textToArrayOfTypes: (text, callbacks...) ->
    textArray = [type: "text", contents: text]
    callbacks.reduce (contentsArray, callback) ->
      callback contentsArray
    , textArray

  extractEmoji: (contentsArray) ->
    contentsArray.reduce (emojiedArray, value) =>
      if value.type isnt "text"
        emojiedArray.push value
      else
        splittedText = value.contents.split(ChatMessageContents.emojiRegex)
        splittedText.forEach (word, index) ->
          emojiedArray.push if not ChatMessageContents.emojiRegex.test(word)
            type: "text"
            contents: word
          else
            type: "emoji"  
            contents: word.match(/:(.+):/)[1]
      emojiedArray
    , []

  extractMentions: (contentsArray) ->
    contentsArray.reduce (mentionedArray, value) =>
      if value.type isnt "text"
        mentionedArray.push value
      else
        splittedText = value.contents.split(ChatMessageContents.mentionRegex)
        splittedText.forEach (word, index) ->
          mentionedArray.push if not ChatMessageContents.mentionRegex.test(word)
            type: "text"
            contents: word
          else
            type: "mention"
            contents: word.match(/@(.+)/)[1]
      mentionedArray
    , []

  createTextReactComponent: (contents) ->
    contents

  createEmojiReactComponent: (contents) ->
    <EmojiPicture name={contents} />

  createMentionReactComponent: (contents) ->
    <Mention name={ contents } />

  arrayOfTypesToReactComponents: (arrayOfTypes) ->
    arrayOfTypes.map (value) =>
      @["create#{_s.capitalize(value.type)}ReactComponent"] value.contents

  renderText: ->
    text = lineTrimmerHelper(@props.text)
    arrayOfTypes = @textToArrayOfTypes(text, @extractEmoji, @extractMentions)
    reactComponents = @arrayOfTypesToReactComponents(arrayOfTypes)

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