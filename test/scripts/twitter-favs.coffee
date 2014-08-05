{Robot, User, TextMessage} = require 'hubot'
assert = require 'power-assert'
path = require 'path'
sinon = require 'sinon'

describe 'hello', ->
  beforeEach (done) ->
    @sinon = sinon.sandbox.create()
    @robot = new Robot(path.resolve(__dirname, '..'), 'shell', false, 'hubot')
    @robot.adapter.on 'connected', =>
      @robot.load path.resolve(__dirname, '../../src/scripts')
      done()
    @robot.run()

  afterEach (done) ->
    @robot.brain.on 'close', =>
      @sinon.restore()
      done()
    @robot.shutdown()

  describe 'listeners[0].regex', ->
    beforeEach ->
      @callback = @sinon.spy()
      @robot.listeners[0].callback = @callback

    describe 'receive "@hubot twitter-favs"', ->
      beforeEach ->
        @sender = new User 'bouzuya', room: 'hitoridokusho'
        message = '@hubot twitter-favs'
        @robot.adapter.receive new TextMessage(@sender, message)

      it 'calls *favs* with "@hubot twitter-favs"', ->
        assert @callback.callCount is 1
        assert @callback.firstCall.args[0].match.length is 2
        assert @callback.firstCall.args[0].match[0] is '@hubot twitter-favs'
        assert @callback.firstCall.args[0].match[1] is undefined

    describe 'receive "@hubot twitter-favs 10"', ->
      beforeEach ->
        @sender = new User 'bouzuya', room: 'hitoridokusho'
        message = '@hubot twitter-favs 10'
        @robot.adapter.receive new TextMessage(@sender, message)

      it 'calls *favs* with "@hubot twitter-favs 10"', ->
        assert @callback.callCount is 1
        assert @callback.firstCall.args[0].match.length is 2
        assert @callback.firstCall.args[0].match[0] is '@hubot twitter-favs 10'
        assert @callback.firstCall.args[0].match[1] is '10'

  describe 'listeners[0].callback', ->
    beforeEach ->
      {Twitter} = require '../../src/twitter'
      @sinon.stub Twitter.prototype, 'getFavorites', (params, callback) ->
        callback [
          id_str: '123456789012345601'
          text: 'hoge fuga piyo 1'
          user:
            screen_name: 'bouzuya'
        ,
          id_str: '123456789012345602'
          text: 'hoge fuga piyo 2'
          user:
            screen_name: 'bouzuya2'
        ,
          id_str: '123456789012345603'
          text: 'hoge fuga piyo 3'
          user:
            screen_name: 'bouzuya3'
        ,
          id_str: '123456789012345604'
          text: 'hoge fuga piyo 4'
          user:
            screen_name: 'bouzuya4'
        ,
          id_str: '123456789012345605'
          text: 'hoge fuga piyo 5'
          user:
            screen_name: 'bouzuya5'
        ,
          id_str: '123456789012345606'
          text: 'hoge fuga piyo 6'
          user:
            screen_name: 'bouzuya6'
        ]
      @favs = @robot.listeners[0].callback

    describe 'HUBOT_TWITTER_FAVS_SHOW_DETAIL is null', ->
      beforeEach ->
        @env = {}
        @env.showDetail = process.env.HUBOT_TWITTER_FAVS_SHOW_DETAIL
        delete process.env.HUBOT_TWITTER_FAVS_SHOW_DETAIL

      afterEach ->
        process.env.HUBOT_TWITTER_FAVS_SHOW_DETAIL = @env.showDetail

      describe 'receive "@hubot twitter-favs"', ->
        beforeEach ->
          @send = @sinon.spy()
          @favs
            match: ["@hubot twitter-favs"]
            send: @send

        it 'send urls', ->
          assert @send.callCount is 1
          assert @send.firstCall.args[0] is '''
            https://twitter.com/bouzuya/status/123456789012345601
            https://twitter.com/bouzuya2/status/123456789012345602
            https://twitter.com/bouzuya3/status/123456789012345603
            https://twitter.com/bouzuya4/status/123456789012345604
            https://twitter.com/bouzuya5/status/123456789012345605
          '''

      describe 'receive "@hubot twitter-favs 3"', ->
        beforeEach ->
          @send = @sinon.spy()
          @favs
            match: ['@hubot twitter-favs 3', '3']
            send: @send

        it 'send urls', ->
          assert @send.callCount is 1
          assert @send.firstCall.args[0] is '''
            https://twitter.com/bouzuya/status/123456789012345601
            https://twitter.com/bouzuya2/status/123456789012345602
            https://twitter.com/bouzuya3/status/123456789012345603
          '''

    describe 'HUBOT_TWITTER_FAVS_SHOW_DETAIL is not null', ->
      beforeEach ->
        @env = {}
        @env.showDetail = process.env.HUBOT_TWITTER_FAVS_SHOW_DETAIL
        process.env.HUBOT_TWITTER_FAVS_SHOW_DETAIL = 1

      afterEach ->
        process.env.HUBOT_TWITTER_FAVS_SHOW_DETAIL = @env.showDetail

      describe 'receive "@hubot twitter-favs"', ->
        beforeEach ->
          @send = @sinon.spy()
          @favs
            match: ["@hubot twitter-favs"]
            send: @send

        it 'send urls & details', ->
          assert @send.callCount is 1
          assert @send.firstCall.args[0] is '''
            https://twitter.com/bouzuya/status/123456789012345601
            bouzuya: hoge fuga piyo 1
            https://twitter.com/bouzuya2/status/123456789012345602
            bouzuya2: hoge fuga piyo 2
            https://twitter.com/bouzuya3/status/123456789012345603
            bouzuya3: hoge fuga piyo 3
            https://twitter.com/bouzuya4/status/123456789012345604
            bouzuya4: hoge fuga piyo 4
            https://twitter.com/bouzuya5/status/123456789012345605
            bouzuya5: hoge fuga piyo 5
          '''
