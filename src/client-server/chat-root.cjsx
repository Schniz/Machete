# @cjsx React.DOM

React = require('react')
ChatTabs = require('./chat-tabs.cjsx')
ChatTextBox = require('./chat-text-box.cjsx')

ChatRoot = React.createClass
  sendToCurrentChatTab: (text) ->
    console.log text

  render: ->
    <div className="chat-root">
      <ChatTabs tabs={@props.tabs} />
      <ChatTextBox onSubmit={@sendToCurrentChatTab} />
    </div>

module.exports = ChatRoot