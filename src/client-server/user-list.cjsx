# @cjsx React.DOM

React = require('react')

UserList = React.createClass
  generateUserItem: (user) ->
    <li key={ user.name }>{ user.name }</li>

  render: ->
    <div className="user-list">
      <span className="user-list-header">
        Online
      </span>
      <ul className="users">
        { @props.users.map(@generateUserItem) }
      </ul>
    </div>

module.exports = UserList