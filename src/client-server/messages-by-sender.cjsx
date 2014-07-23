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

  addMessageWat: ->
    @addMessage sentAt: new Date, contents: prompt('wat', 'wat'), _id: Math.random()

  render: ->
    <li className="messages-by-sender" onClick={@addMessageWat}>
      <ChatMessageProfilePic src={ @props.user.profilePic } />
      <div className="messages-container">
        <span className="sender">{ @props.user.nickname }:</span>
        <ol className="chatmessages">
          { @state.messages.map(@messageContainer) }
        </ol>
      </div>
    </li>

module.exports = MessagesBySender