# @cjsx React.DOM

React = require('react')
_s = require('underscore.string')
gemoji = require('gemoji')
Mention = require('./mention.cjsx')
lineTrimmerHelper = require('./line-trimmer-helper.cjsx')
EmojiPicture = require('./emoji-picture.cjsx')

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

  createTextReactComponent: (contents, index) ->
    <span key="text-#{index}">{ contents }</span>

  createEmojiReactComponent: (contents, index) ->
    <EmojiPicture name={contents} key="emoji-#{index}" />

  createMentionReactComponent: (contents, index) ->
    <Mention name={ contents } key="mention-#{index}" />

  arrayOfTypesToReactComponents: (arrayOfTypes) ->
    arrayOfTypes.map (value, index) =>
      @["create#{_s.capitalize(value.type)}ReactComponent"] value.contents, index

  renderText: ->
    text = lineTrimmerHelper(@props.text)
    arrayOfTypes = @textToArrayOfTypes(text, @extractEmoji, @extractMentions)
    reactComponents = @arrayOfTypesToReactComponents(arrayOfTypes)

  render: ->
    <span dir="auto" ref="text" className="contents">{ @renderText() }</span>

module.exports = ChatMessageContents