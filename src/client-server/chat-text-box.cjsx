# @cjsx React.DOM

React = require('react/addons')
$ = require('jquery');

lineTrimmerHelper = require('./line-trimmer-helper.cjsx')

ChatTextBox = React.createClass
  componentDidMount: ->
    $(@refs.textarea.getDOMNode()).expanding().focus()

  onSubmit: -> 
    value = lineTrimmerHelper(@refs.textarea.getDOMNode().value)
    @props.onSubmit value if value isnt ""

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