Machete ![Travis CI](https://travis-ci.org/Schniz/Machete.svg)
=======

Chat for your org.
wat wat wat wat

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