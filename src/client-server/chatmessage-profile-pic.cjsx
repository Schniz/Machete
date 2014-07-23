# @cjsx React.DOM

React = require('react')

ChatMessageProfilePic = React.createClass
  render: ->
    <div>
      <img src={ @props.src } className="chatmessage-profile-pic" />
    </div>

module.exports = ChatMessageProfilePic