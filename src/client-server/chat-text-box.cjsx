# @cjsx React.DOM

React = require('react/addons')
$ = require('jquery')
gemoji = require('gemoji')
EmojiPicture = require('./emoji-picture.cjsx')

lineTrimmerHelper = require('./line-trimmer-helper.cjsx')

ChatTextBox = React.createClass
  getInitialState: ->
    atWhoLastHidden: 0

  displayName: "ChatTextBox"

  getTextAreaDOM: ->
    @refs.textarea.getDOMNode()

  hiddenAtWho: ->
    @setState atWhoLastHidden: new Date().getTime()

  getEmojis: ->
    Object.keys(gemoji.name).map (name) ->
      name: name

  componentWillReceiveProps: (nextProps) ->
    $(@getTextAreaDOM()).atwho('load', '@', nextProps.userList)

  componentDidMount: ->
    emojiPicture = React.renderComponentToString(<EmojiPicture name='${name}' />)

    $(@getTextAreaDOM()).expanding().atwho
      at: "@"
      data: @props.userList
    .atwho
      at: ":"
      data: @getEmojis()
      tpl: "<li data-value=':${name}:'>#{emojiPicture} ${name} </li>"
    .on("hidden.atwho", @hiddenAtWho)
    .focus()

  justClosedAtWhoWindow: ->
    new Date().getTime() - @state.atWhoLastHidden < 100

  onSubmit: -> 
    value = lineTrimmerHelper(@refs.textarea.getDOMNode().value)
    @props.onSubmit value if value isnt ""

  clear: -> $(@refs.textarea.getDOMNode()).val("").change()

  onKeyDown: (evnt) ->
    if (evnt.key is 'Enter' and not evnt.shiftKey and not @justClosedAtWhoWindow())
      console.log @state.shownAtWho
      evnt.stopPropagation()
      evnt.preventDefault()
      @onSubmit()

  render: ->
    <div className="chat-text-box">
      <textarea dir="auto" ref="textarea" onKeyDown={ @onKeyDown } className="textarea" rows="1" placeholder="Free your mind...">
      </textarea>
    </div>

module.exports = ChatTextBox