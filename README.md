
Machete ![Travis CI](https://travis-ci.org/Schniz/Machete.svg)
=======

Chat for your org.
wat wat wat wat

Screenshot
----------

![Machete.](http://f.cl.ly/items/1R0n0G243B0s1J0m3A3O/Image%202014-07-26%20at%204.09.01%20PM.png)

But as you know, it may have been updated since the last commits. yeah.

Installation
------------

```bash
git clone......
npm install
bower install
gulp build
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