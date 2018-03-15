# Description:
#   Nomlish translate in hubot.
#   http://racing-lagoon.info/nomu/translate.php
#
# Dependencies:
#   "request": "~2.27.0"
#   "cheerio": "~0.12.1"
#
# Configuration:
#   None
#
# Commands:
#   hubot nomlish <Japanese> [<level(1-6)>] - Translating from Japanese into Nomlish. Default level is 2.
#
# Notes:
#   "anchk" option is not appointed.
#
# Author:
#   shinya.saiho

request = require 'request'
cheerio = require 'cheerio'

request = request.defaults
  jar: true

module.exports = (robot) ->
  robot.respond /NOMLISH (.+)/i, (msg) ->
    params = form:
      transbtn: 1
      options: 'nochk'

    levelMatch = msg.match[1].match /\s([1-6])$/
    if levelMatch?
      params.form.before = msg.match[1].slice(0, -2)
      params.form.level = levelMatch[1]
    else
      params.form.before = msg.match[1]
      params.form.level = 2

    url = 'https://racing-lagoon.info/nomu/translate.php'
    errormsg = 'ERROR: 通信が断罪＜クライム＞しました'

    request url, (error, response, body) ->
      if error or response.statusCode != 200
        msg.send errormsg
      else
        $ = cheerio.load body
        params.form.token = $('input[name="token"]').val()
        request.post url, params, (error, response, body) ->
          if error or response.statusCode != 200
            msg.send errormsg
          else
            $ = cheerio.load body
            msg.send $('textarea[name="after1"]').text()
