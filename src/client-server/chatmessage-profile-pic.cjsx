# @cjsx React.DOM

React = require('react')

ChatMessageProfilePic = React.createClass
  picture: ->
    "/api/v1/users/#{ @props.nickname }/picture"

  render: ->
    <div>
      <img src={ @picture() } className="chatmessage-profile-pic" />
    </div>

module.exports = ChatMessageProfilePic