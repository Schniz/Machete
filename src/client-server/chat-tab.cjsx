# @cjsx React.DOM

React = require('react')

MessagesBySender = require('./messages-by-sender.cjsx')

ChatTab = React.createClass
  getInitialState: ->
    userMessages: @messagesToUserMessages(@props.messages)

  extractMessage: (message) ->
    user: message.user
    contents: 
      contents: message.contents
      sentAt: message.sentAt
      _id: message._id
 
  handleMessage: (userMessages, message) ->
    lastUserMessages = userMessages[userMessages.length - 1]
    lastUser = lastUserMessages?.user
    messageContents = @extractMessage message

    if message.user is lastUser
      lastUserMessages.messages.push messageContents.contents
    else
      userMessages.push
        messages: [ messageContents.contents ]
        user: messageContents.user

    userMessages

  messagesToUserMessages: (messages) ->
    messages.reduce @handleMessage, []

  generateUserMessages: (userMessages) ->
    userKey = "#{userMessages.user}@#{userMessages.messages[0].sentAt.getTime()}"
    <MessagesBySender key={ userKey } user={ userMessages.user } messages={ userMessages.messages } />

  render: ->
    <ol>
      { @state.userMessages.map(@generateUserMessages) }
    </ol>

module.exports = ChatTab