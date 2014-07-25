# @cjsx React.DOM

React = require('react/addons')
ChatTabs = require('./chat-tabs.cjsx')
ChatTextBox = require('./chat-text-box.cjsx')
io = require('socket.io-client')
uuid = require('node-uuid')

ChatRoot = React.createClass
  componentDidMount: ->
    @createSocket()
    @bindSocketEvents()

  createSocket: ->
    @socket = io.connect()
    @socket.emit("room", { name: "#{@props.name}", token: @props.token });

  bindSocketEvents: ->
    @socket.on 'sendMessage:result', @onSendMessageResult
    @socket.on 'sendMessage', @onSendMessage

  onSendMessageResult: (result) ->
    @refs.chatTabs.updateTemporaryMessageOnTab
      tab: result.room
      oldId: result.tempId
      newId: result.newId
      ok: result.ok

  onSendMessage: (messageReceived) ->
    message =
      _id: messageReceived._id
      sentAt: moment(messageReceived.sentAt).toDate()
      contents: messageReceived.contents
      user: messageReceived.user

    @addMessage message

  sendToCurrentChatTab: (text, callback) ->
    tab = @refs.chatTabs.state.currentTab
    tempId = uuid.v1()

    @socket.emit 'sendMessage',
      tempId: tempId
      contents: text
      accessToken: 'watwat'
      room: tab

    @refs.chatTabs.addMessageToTab 
      tab: tab
      message:
        _id: tempId
        contents: text
        user: 'schniz'
        sentAt: new Date()
        isTemporaryId: true

    @refs.textBox.clear()

  render: ->
    <div className="chat-root">
      <ChatTabs ref="chatTabs" tabs={@props.tabs} />
      <ChatTextBox ref="textBox" onSubmit={@sendToCurrentChatTab} />
    </div>

module.exports = ChatRoot