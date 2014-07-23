# @cjsx React.DOM

React = require('react')
$ = require('jquery');

ChatTextBox = React.createClass
  componentDidMount: ->
    $(@refs.textarea.getDOMNode()).expanding()

  render: ->
    <div className="chat-text-box">
      <textarea ref="textarea" className="textarea" rows="1" placeholder="Free your mind...">
      </textarea>
      <button className="send-button">Send</button>
    </div>

module.exports = ChatTextBox