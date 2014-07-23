# @cjsx React.DOM

React = require('react')
ChatTab = require('./chat-tab.cjsx')

ChatTabs = React.createClass
  sendToCurrentChatTab: (text, callback) ->
    @refs.chatTab.addMessage
      contents: text
      user: 'schniz'
      sentAt: new Date()
      _id: Math.random() * 1000000

    callback()

  render: ->
    <div className="chat-tabs">
      <ChatTab ref="chatTab" messages={@props.tabs.main.messages} />
    </div>

module.exports = ChatTabs