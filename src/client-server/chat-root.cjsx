# @cjsx React.DOM

React = require('react/addons')
ChatTabs = require('./chat-tabs.cjsx')
ChatTextBox = require('./chat-text-box.cjsx')
UserList = require('./user-list.cjsx')
io = require('socket.io-client')
uuid = require('node-uuid')
moment = require('moment')
_ = require('lodash')

ChatRoot = React.createClass
  displayName: "ChatRoot"
  getInitialState: ->
    token: prompt('enter token')
    user: null
    userList: []

  componentDidMount: ->
    @createSocket()
    @bindSocketEvents()
    @getUserList()

  getUserList: ->
    @setState userList: @refs.chatTabs.getCurrentTab().getUserList()

  createSocket: ->
    @socket.disconnect() if @socket
    @socket = io.connect "/",
      query: "accessToken=#{ @state.token }"

  bindSocketEvents: ->
    @socket.on 'sendMessage:response', @onSendMessageResponse
    @socket.on 'sendMessage', @onSendMessage
    @socket.on 'listUsers:response', @onListUsersResponse
    @socket.on 'welcome', @onWelcome
    @socket.on 'disconnect', @onDisconnect

  onDisconnect: ->
    @sendDisconnectedMessage @state.user
    @clearUserLists()

  clearUserLists: ->
    @refs.chatTabs.getTabs().forEach (tab) ->
      tab.setUserList []
    @getUserList()

  sendDisconnectedMessage: (user) ->
    fakeUser = uuid.v1()
    @sendToAllTabs
      _id: "joe@#{ fakeUser }"
      sentAt: new Date()
      contents: "you just disconnected from server."
      user: fakeUser
      realUser: user
      isServerMessage: true

  sendToAllTabs: (message) ->
    @refs.chatTabs.getTabNames().forEach (tabName) =>
      @onSendMessage _.extend(message, room: tabName)

  onListUsersResponse: (res) ->
    @refs.chatTabs.getTab(res.room).setUserList res.userList
    @getUserList()

  onWelcome: (welcome) ->
    console.log "connected with id #{welcome.id}"
    @setState user: welcome.user
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

    if not message.realUser? or message.realUser isnt @state.user
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
        user: @state.user
        sentAt: new Date()
        isTemporaryId: true

    @refs.textBox.clear()

  render: ->
    <div className="chat-root">
      <div className="chat-holder">
        <UserList users={ @state.userList } key="userList" ref="userList" />
        <ChatTabs initialTab="main" ref="chatTabs" tabs={@props.tabs} />
      </div>
      <ChatTextBox userList={ @state.userList } ref="textBox" onSubmit={@sendToCurrentChatTab} />
    </div>

module.exports = ChatRoot