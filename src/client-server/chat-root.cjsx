# @cjsx React.DOM

React = require('react/addons')
ChatTabs = require('./chat-tabs.cjsx')
ChatTextBox = require('./chat-text-box.cjsx')
io = require('socket.io-client')
uuid = require('node-uuid')
moment = require('moment')

ChatRoot = React.createClass
  getInitialState: ->
    token: 'watwat'

  componentDidMount: ->
    @createSocket()
    @bindSocketEvents()

  createSocket: ->
    @socket.disconnect() if @socket
    @socket = io.connect "/",
      query: "accessToken=#{ @state.token }"

  bindSocketEvents: ->
    @socket.on 'sendMessage:response', @onSendMessageResponse
    @socket.on 'sendMessage', @onSendMessage
    @socket.on 'listUsers:response', @onListUsersResponse
    @socket.on 'welcome', @onWelcome

  onListUsersResponse: (res) ->
    console.log "listUsers:response", res

  onWelcome: (socketId) ->
    console.log "connected with id #{socketId}"
    @refs.chatTabs.state.tabs.forEach (room) =>
      @socket.emit "room", 
        name: room
        token: @state.token
      @socket.emit "listUsers",
        room: room
        token: @state.token

  onSendMessageResponse: (result) ->
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
      isServerMessage: messageReceived.isServerMessage
      realUser: messageReceived.realUser

    @refs.chatTabs.addMessageToTab
      tab: messageReceived.room
      message: message

  sendToCurrentChatTab: (text, callback) ->
    tab = @refs.chatTabs.state.currentTab
    tempId = uuid.v1()

    console.log "sending message to tab #{tab}"

    @socket.emit 'sendMessage',
      tempId: tempId
      contents: text
      accessToken: @state.token
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
      <ChatTabs initialTab="main" ref="chatTabs" tabs={@props.tabs} />
      <ChatTextBox ref="textBox" onSubmit={@sendToCurrentChatTab} />
    </div>

module.exports = ChatRoot