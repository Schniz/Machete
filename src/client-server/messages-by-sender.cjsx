# @cjsx React.DOM

React = require('react')

ChatMessageProfilePic = require('./chatmessage-profile-pic.cjsx')
ChatMessage = require('./chatmessage.cjsx')

MessagesBySender = React.createClass
  getInitialState: ->
    messages: @props.messages
  
  messageContainer: (message, index) ->
    <ChatMessage key={ message._id } contents={ message.contents } id={ message._id } sentAt={ message.sentAt } isLast={ index + 1 is @state.messages.length } />

  addMessage: (message) ->
    messages = @state.messages
    messages.push message
    @setState messages: messages

  render: ->
    <li className="messages-by-sender">
      <ChatMessageProfilePic nickname={ @props.user } />
      <div className="messages-container">
        <span className="sender">{ @props.user }:</span>
        <ol className="chatmessages">
          { @state.messages.map(@messageContainer) }
        </ol>
      </div>
    </li>

module.exports = MessagesBySender