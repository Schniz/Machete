window.Helpers = require('../client/helpers.cjsx')

MessagesBySender = require('./messages-by-sender.cjsx')

React = require('react')

user =
  profilePic: '/images/gal.jpg'
  nickname: 'schniz'

messages = [
  {
    _id: 'abcdefg'
    contents: "Gal Hagever haya po!"
    sentAt: new Date()
  }
]

React.renderComponent <MessagesBySender user={ user } messages={ messages } />, document.body