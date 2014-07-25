# @cjsx React.DOM

React = require('react/addons')
update = React.addons.update
moment = require('moment')

MessagesBySender = require('./messages-by-sender.cjsx')

ChatTab = React.createClass
  getInitialState: ->
    userMessages: @messagesToUserMessages(@props.messages)
    scrollTop: 0

  addMessage: (message) ->
    @setState userMessages: @handleMessage(@state.userMessages, message)
    @scrollToBottom()

  extractMessage: (message) ->
    user: message.user
    contents: 
      contents: message.contents
      sentAt: message.sentAt
      _id: message._id
      isTemporaryId: message.isTemporaryId

  changeMessageId: (opts) ->
    { from, to } = opts
    console.log "changeing from #{from} to #{to}"
    newUserMessages = @state.userMessages.map (userMessages) ->
      indexOfMessageId = userMessages.messageIds.indexOf(from)
      if indexOfMessageId is -1
        userMessages
      else
        userMessages.messageIds.splice indexOfMessageId, 1
        userMessages.messages = userMessages.messages.map (message) ->
          if message._id isnt from
            message
          else
            message._id = to
            delete message.isTemporaryId
            message

        userMessages

    @setState userMessages: newUserMessages
    console.log newUserMessages
 
  errorOnMessage: (id) ->
    console.log "error on message #{id}"

  shouldCreateNewUserMessage: (message) ->
    timeDiffInSeconds = moment(new Date()).diff(moment(message.sentAt), 'minutes') > 2

  handleMessage: (userMessages, message) ->
    lastUserMessages = userMessages[userMessages.length - 1]
    lastUserMessage = lastUserMessages?.messages[lastUserMessages.messages?.length - 1]
    lastUser = lastUserMessages?.user
    messageContents = @extractMessage message

    if message.user is lastUser and not @shouldCreateNewUserMessage(lastUserMessage)
      lastUserMessages.messages.push messageContents.contents
      lastUserMessages.messageIds.push messageContents.contents._id
    else
      userMessages.push
        messages: [ messageContents.contents ]
        messageIds: [ messageContents.contents._id ]
        user: messageContents.user

    userMessages

  messagesToUserMessages: (messages) ->
    messages.reduce @handleMessage, []

  generateUserMessages: (userMessages) ->
    userKey = "#{userMessages.user}@#{userMessages.messages[0].sentAt.getTime()}"
    <MessagesBySender parentScrollTop={ @state.scrollTop } key={ userKey } user={ userMessages.user } messages={ userMessages.messages } />

  scrollToBottom: ->
    node = @getDOMNode()
    node.scrollTop = node.scrollHeight

  componentDidMount: ->
    @scrollToBottom()

  onScroll: ->
    @setState scrollTop: @getDOMNode().scrollTop

  render: ->
    <ol ref="userMessagesList" className="chat-tab" onScroll={ @onScroll }>
      { @state.userMessages.map(@generateUserMessages) }
    </ol>

module.exports = ChatTab