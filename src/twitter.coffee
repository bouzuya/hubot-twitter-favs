Twitter = require 'twitter'

Twitter.prototype.getFavorites = (params, callback) ->
  url = '/favorites/list.json'
  @get url, params, callback
  @

module.exports = {Twitter}
