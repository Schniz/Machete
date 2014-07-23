# @cjsx React.DOM

React = require('react')
ChatTabs = require('./chat-tabs.cjsx')
ChatTextBox = require('./chat-text-box.cjsx')

ChatRoot = React.createClass
  sendToCurrentChatTab: (text, callback) ->
    @refs.chatTabs.sendToCurrentChatTab text, callback

  render: ->
    <div className="chat-root">
      <ChatTabs ref="chatTabs" tabs={@props.tabs} />
      <ChatTextBox onSubmit={@sendToCurrentChatTab} />
    </div>

module.exports = ChatRoot