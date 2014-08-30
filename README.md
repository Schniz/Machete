
Machete ![Travis CI](https://travis-ci.org/Schniz/Machete.svg)
=======

Chat for your org.
wat wat wat wat

Screenshot
----------

![Machete.](https://cloud.githubusercontent.com/assets/2054772/4099240/58911dee-3053-11e4-82b7-b5d113dc6cbc.png)

But as you know, it may have been updated since the last commits. yeah.

Installation
------------
assuming you have [`gulp`](http://gulpjs.com/) installed.. (`npm install -g gulp`)

```bash
git clone......
gulp install
echo "ARE YOU READY????????????"
node .
```

React Hirarchy
--------------

- PageRoot
  - Header
  - ChatRoot
    - UserList
    - ChatWindow
      - ChatTabs (list)
        - ChatTab..
        - ChatTab..
        - ChatTab
          - MessagesBySender (list)
            - Message..
            - Message..
            - Message
    - ChatTextBox
      - AtJsTextBox(:emoji: + @mentions)
      - SendButton(also via Enter Key)

Url Hirarchy
------------
- `/` => `/main`
- `/:roomName` for room name. will only swap/open tabs on HTML5 stuff.
  - roomName param can be room name (alphanumerical) or `nick@nick@nick@...` for group messaging.