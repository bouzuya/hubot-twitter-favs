# hubot-twitter-favs

A Hubot script that display twitter favs.

## Installation

    $ npm install git://github.com/bouzuya/hubot-twitter-favs.git

or

    $ # TAG is the package version you need.
    $ npm install 'git://github.com/bouzuya/hubot-twitter-favs.git#TAG'

## Sample Interaction

    bouzuya> hubot help twitter-favs
    hubot> hubot twitter-favs - display twitter favs

    bouzuya> hubot twitter-favs
    hubot> https://twitter.com/bouzuya/status/496512774566981632
    bouzuya: hoge fuga piyo
    https://twitter.com/bouzuya/status/496512774566981653
    bouzuya: fav fav fav

See [`src/scripts/twitter-favs.coffee`](src/scripts/twitter-favs.coffee) for full documentation.

## License

MIT

## Development

### Run test

    $ npm test

### Run robot

    $ npm run robot


## Badges

[![Build Status][travis-status]][travis]

[travis]: https://travis-ci.org/bouzuya/hubot-twitter-favs
[travis-status]: https://travis-ci.org/bouzuya/hubot-twitter-favs.svg?branch=master
