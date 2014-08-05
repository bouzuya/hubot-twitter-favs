# Description
#   A Hubot script that display twitter favs
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_TWITTER_FAVS_API_KEY
#   HUBOT_TWITTER_FAVS_API_SECRET
#   HUBOT_TWITTER_FAVS_ACCESS_TOKEN
#   HUBOT_TWITTER_FAVS_ACCESS_TOKEN_SECRET
#   HUBOT_TWITTER_FAVS_SHOW_DETAIL
#
# Commands:
#   hubot twitter-favs [<N>] - display twitter favs
#
# Author:
#   bouzuya <m@bouzuya.net>
#
module.exports = (robot) ->
  {Promise} = require 'q'
  {Twitter} = require '../twitter'

  favs = (count) ->
    new Promise (resolve, reject) ->
      twitter = new Twitter
        consumer_key:        process.env.HUBOT_TWITTER_FAVS_API_KEY
        consumer_secret:     process.env.HUBOT_TWITTER_FAVS_API_SECRET
        access_token_key:    process.env.HUBOT_TWITTER_FAVS_ACCESS_TOKEN
        access_token_secret: process.env.HUBOT_TWITTER_FAVS_ACCESS_TOKEN_SECRET
      twitter.getFavorites {}, (data) ->
        if data instanceof Error
          reject data
        else
          resolve data

  format = (favs) ->
    favs
      .map (fav) ->
        url = "https://twitter.com/#{fav.user.screen_name}/status/#{fav.id_str}"
        url + if process.env.HUBOT_TWITTER_FAVS_SHOW_DETAIL? then """
          \n#{fav.user.screen_name}: #{fav.text}
        """ else ''
      .join '\n'

  robot.respond /twitter-favs(?:\s+(\d+))?\s*$/i, (res) ->
    count = res.match[1] ? 5
    favs count
      .then (favs) ->
        res.send format(favs.filter((item, i) -> i < count))
      , (e) ->
        robot.logger.error e
        res.send 'twitter-favs: error'
