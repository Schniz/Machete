window.Helpers = require('../client/helpers.cjsx')
ChatRoot = require('./chat-root.cjsx')

window.React = React = require('react/addons')
React.addons.Perf.start()

tabs =
  main:
    messages: [
    ]

# [3..10].forEach (id)->
#   tabs.main.messages.push
#     _id: id
#     contents: "Gal Hagever haya po #{id}!"
#     sentAt: new Date()
#     user: 'schniz'


React.renderComponent <ChatRoot tabs={ tabs } />, document.body