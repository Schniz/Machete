# @cjsx React.DOM

React = require('react')

EmojiPicture = React.createClass
  getDefaultProps: ->
    height: 20
    width: 20

  render: ->
    <img src={ "http://a248.e.akamai.net/assets.github.com/images/icons/emoji/#{ @props.name }.png" } height={ @props.height } width={ @props.width }/>

module.exports = EmojiPicture