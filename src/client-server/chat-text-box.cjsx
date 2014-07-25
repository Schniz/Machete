# @cjsx React.DOM

React = require('react/addons')
$ = require('jquery');

ChatTextBox = React.createClass
  componentDidMount: ->
    $(@refs.textarea.getDOMNode()).expanding().focus()

  onSubmit: -> @props.onSubmit @refs.textarea.getDOMNode().value
  clear: -> $(@refs.textarea.getDOMNode()).val("").change()

  onKeyDown: (evnt) ->
    if (evnt.key is 'Enter' and not evnt.shiftKey)
      evnt.preventDefault()
      @onSubmit()

  render: ->
    <div className="chat-text-box">
      <textarea dir="auto" ref="textarea" onKeyDown={ @onKeyDown } className="textarea" rows="1" placeholder="Free your mind...">
      </textarea>
    </div>

module.exports = ChatTextBox