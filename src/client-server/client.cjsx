window.Helpers = require('../client/helpers.cjsx')

ChatTab = require('./chat-tab.cjsx')

React = require('react')

messages = [
  {
    _id: 'abcdefg'
    contents: "Gal Hagever haya po!"
    sentAt: new Date()
    user: 'schniz'
  }
  {
    _id: 'abcdefg2'
    contents: "Gal Hagever haya po 2222222!"
    sentAt: new Date()
    user: 'schniz'
  }
]

React.renderComponent <ChatTab messages={ messages } />, document.body