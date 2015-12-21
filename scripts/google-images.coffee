# Description:
#   A way to interact with the Google Images API.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   image me (query)    - The Original. Queries Google Images for (query) and returns a random top
#   result.
#

qs = require('querystring')
https = require('https')
u = require('underscore')
cseAPIKey = "AIzaSyCjr3KlMUXpWiMl6HLnbK025k4HTMDNtms"

module.exports = (robot) ->
  robot.respond /(image|img)( me)?( \d)? (.*)/i, (msg) ->
    [_, _, _, num, query] = msg.match
    num = if num then parseInt(num) else 1
    # shove query into google custom search
    query_options = {
      q: query
      key: cseAPIKey
      cx: "007769574389294976137:tti31yos8ky"
      searchType : "image"
    }
    options =
      hostname: "www.googleapis.com"
      path: "/customsearch/v1?#{qs.stringify(query_options)}"

    https.get options, (res) ->
      data = []

      if res.statusCode == 200
        res.on 'data', (chunk) ->
          data.push(chunk)
        res.on 'end', ->
          images = JSON.parse(data.join(''))
          if images.items?
            u.sample(images.items, num).forEach (image) -> msg.send (image.link)
          else
            msg.send "Couldn't find any images"
      else
        msg.send "Image search failed!"
