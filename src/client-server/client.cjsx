window.Helpers = require('../client/helpers.cjsx')

ChatRoot = require('./chat-root.cjsx')

React = require('react')

tabs =
  main:
    messages: [
      {
        _id: 1
        contents: "Gal Hagever haya po!"
        sentAt: new Date()
        user: 'schniz'
      }
      {
        _id: 2
        contents: "Gal Hagever haya po 2222222!"
        sentAt: new Date()
        user: 'schniz'
      }
    ]

[3..10].forEach (id)->
  tabs.main.messages.push
    _id: id
    contents: "Gal Hagever haya po #{id}!"
    sentAt: new Date()
    user: 'schniz'

React.renderComponent <ChatRoot tabs={ tabs } />, document.body