# @cjsx React.DOM

React = require('react')
$ = require('jquery');

ChatTextBox = React.createClass
  componentDidMount: ->
    $(@refs.textarea.getDOMNode()).expanding()

  onSubmit: ->
    textarea = @refs.textarea.getDOMNode()
    value = textarea.value

    @props.onSubmit value, (err) ->
      $(textarea).val("").change() unless err

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