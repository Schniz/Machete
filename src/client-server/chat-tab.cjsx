# @cjsx React.DOM

React = require('react')
moment = require('moment')

MessagesBySender = require('./messages-by-sender.cjsx')

ChatTab = React.createClass
  getInitialState: ->
    userMessages: @messagesToUserMessages(@props.messages)

  addMessage: (message) ->
    @setState userMessages: @handleMessage(@state.userMessages, message)

  extractMessage: (message) ->
    user: message.user
    contents: 
      contents: message.contents
      sentAt: message.sentAt
      _id: message._id
 
  shouldCreateNewUserMessage: (message) ->
    timeDiffInSeconds = moment(new Date()).diff(moment(message.sentAt), 'minutes') > 1

  handleMessage: (userMessages, message) ->
    lastUserMessages = userMessages[userMessages.length - 1]
    lastUserMessage = lastUserMessages?.messages[lastUserMessages.messages?.length - 1]
    lastUser = lastUserMessages?.user
    messageContents = @extractMessage message

    if message.user is lastUser and not @shouldCreateNewUserMessage(lastUserMessage)
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

  scrollToBottom: ->
    node = @getDOMNode()
    node.scrollTop = node.scrollHeight

  componentDidMount: ->
    @scrollToBottom()

  render: ->
    <ol className="chat-tab">
      { @state.userMessages.map(@generateUserMessages) }
    </ol>

module.exports = ChatTab