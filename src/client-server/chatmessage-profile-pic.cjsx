# @cjsx React.DOM

React = require('react/addons')

ChatMessageProfilePic = React.createClass
  picture: ->
    "/api/v1/users/#{ @props.nickname }/picture"

  render: ->
    style =
      backgroundImage: "url(#{ @picture() })"

    <div>
      <div style={ style } className="chatmessage-profile-pic" />
    </div>

module.exports = ChatMessageProfilePic