# @cjsx React.DOM

React = require('react')
ChatTab = require('./chat-tab.cjsx')

ChatTabs = React.createClass
  render: ->
    <div className="chat-tabs">
      <ChatTab messages={@props.tabs.main.messages} />
    </div>

module.exports = ChatTabs