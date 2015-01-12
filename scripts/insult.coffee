# Description:
# Let's get some food truck data
#
# Commands:
#   hubot insult
#   hubot call <user name> a <insult> - reply " <user name>, you're a <insult>"

_ = require "lodash"

module.exports = (robot) ->
  robot.respond /insult (.*)/i, (msg) ->
    robot.http("http://pleaseinsult.me/api?severity=extreme")
      .get() (err, res, body) ->
        response = JSON.parse(body)
        name = msg.match[1].trim()

        new_insult = _.map(response.insult.split(" "), (word) ->
          new_word = ""
          word = word.replace(".", "")
          word = word.replace(",", "")

          if word.toLowerCase() is "you're"
            new_word = name + "'s"
          else if word.toLowerCase() is "your"
            new_word = name + "'s"
          else if word.toLowerCase() is "you"
            new_word = name
          else new_word = word
        )

        msg.send new_insult.join(' ')

  robot.respond /call (.*) a (.*)/i, (msg) ->
    name = msg.match[1].trim()
    insult = msg.match[2].trim()

    # switch statement for easter egg replies
    response = switch insult
      when "liar" then "lying liar who lies with their liar mouth"
      else insult

    msg.send "#{name}, you're a #{response}"