# @cjsx React.DOM

React = require('react/addons')
ChatTab = require('./chat-tab.cjsx')

ChatTabs = React.createClass
  getInitialState: ->
    currentTab: @props.initialTab
    tabs: [ @props.initialTab ]

  addMessageToTab: (opts)->
    { message, tab } = opts
    @refs.chatTab.addMessage message

  getTab: (tab) ->
    @refs.chatTab

  updateTemporaryMessageOnTab: (opts)->
      { tab, oldId, newId, ok } = opts
      if ok
        @getTab(tab).changeMessageId from: oldId, to: newId
      else
        @getTab(tab).errorOnMessage oldId

  render: ->
    <div className="chat-tabs">
      <ChatTab name="main" ref="chatTab" messages={@props.tabs.main.messages} />
    </div>

module.exports = ChatTabs