# @cjsx React.DOM

React = require('react/addons')

ChatMessageProfilePic = require('./chatmessage-profile-pic.cjsx')
ChatMessage = require('./chatmessage.cjsx')
StickyChatMessageHeader = require('./sticky-chatmessage-header.cjsx')

MessagesBySender = React.createClass
  getInitialState: ->
    finishedSticking: false
    sticking: false
    clientPosition:
      top: 0
      bottom: 0
  
  messageContainer: (message, index) ->
    <ChatMessage isTemporaryId={ message.isTemporaryId } key={ message.sentAt.getTime() } contents={ message.contents } id={ message._id } sentAt={ message.sentAt } isLast={ index + 1 is @props.messages.length } />

  # componentWillUpdate: (prevProps, prevState) ->()
  #   node = @getDOMNode
  #   @setState
  #     clientPosition:
  #       top: node.clientTop
  #       bottom: node.clientTop + node.clientHeight

  getOffset: (elem) ->
    elem = @getDOMNode() unless elem

    x = elem.offsetLeft
    y = elem.offsetTop

    while elem = elem.offsetParent
      x += elem.offsetLeft
      y += elem.offsetTop

    left: x, top: y

  calculatePosition: ->
    node = @refs.messageContainer.getDOMNode()
    top = @getOffset(node).top

    @setState
      clientPosition:
        top: top
        bottom: top + node.clientHeight
  
  render: ->
    <li ref="root" className="messages-by-sender">
      <ChatMessageProfilePic nickname={ @props.user } />
      <div ref="messageContainer" className="messages-container">
        <span className="sender">{ @props.user }:</span>
        <ol className="chatmessages">
          { @props.messages.map(@messageContainer) }
        </ol>
      </div>
    </li>

module.exports = MessagesBySender