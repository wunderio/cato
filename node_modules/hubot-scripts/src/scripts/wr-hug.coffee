# Description:
#   Track WR hugs
#
# Dependencies:
#   None
#
# Configuration:
#   WR_HUG_ALLOW_SELF
#
# Commands:
#   hubot hug <thing> - give thing a hug
#   hubot hug show <thing> - check thing's hugs (if <thing> is omitted, show the top 5)
#   hubot hug most - show the most 5 hugged people
#   hubot hug least - show the least 5 hugged people
#
# Author:
#   joe baker, forked from karma.coffee


class WRHug

  constructor: (@robot) ->
    @cache = {}

    @increment_responses = [
      "+1!",
      "hugged!",
      "got an oxytocin boost!",
      "got a huge hug!",
      "incoming hug! Mmm, you smell good!",
      "is my big bear!",
      "has been grabbed in a hug so ferocious, the love reached clean to the bones.",
      "can you remember anyone hugging you like this before?",
      "hug hug, kiss kiss, hug hug, big kiss, little hug, kiss kiss, little kiss",
      "do you love warm hugs? You got one!",
      "got a hug! - the universal medicine.",
      "- hug bomb!",
      "hug you, mwah, mwah!",
      "you got a full-on hug - call HR!",
      "you got a very shy, English hug.",
      "hugs from robots aren't the softest, but here's one for you.",
      "toughen up, son, here's a hug for you. When I were a lad we ne'er 'ad hugs. We just got beaten."
    ]

    # @decrement_responses = [
    #   "took a hit! Ouch.", "took a dive.", "lost a life.", "lost a level."
    # ]

    @robot.brain.on 'loaded', =>
      if @robot.brain.data.wrhug
        @cache = @robot.brain.data.wrhug

  kill: (thing) ->
    delete @cache[thing]
    @robot.brain.data.wrhug = @cache

  increment: (thing) ->
    @cache[thing] ?= 0
    @cache[thing] += 1
    @robot.brain.data.wrhug = @cache

  incrementResponse: ->
     @increment_responses[Math.floor(Math.random() * @increment_responses.length)]
     
  dropResponses: (sender, subject) ->
     @drop_responses = [
       "OK @#{sender.mention_name}, you can let go of @#{subject} now.",
       "Right, @#{sender.mention_name}, put @#{subject} down right now! That's quite enough of that.",
       "Hey, you, yes you @#{sender.mention_name}, I can see you still hugging @#{subject} - time to stop now."
     ]

  selfDeniedResponses: (name) ->
    @self_denied_responses = [
      "Hey everyone! #{name} is a narcissist!",
      "I might just allow that next time, but no.",
      "I can't do that #{name}."
    ]

  get: (thing) ->
    h = if @cache[thing] then @cache[thing] else 0
    return h

  sort: ->
    s = []
    for key, val of @cache
      s.push({ name: key, wrhug: val })
    s.sort (a, b) -> b.wrhug - a.wrhug

  top: (n = 5) ->
    sorted = @sort()
    sorted.slice(0, n)

  bottom: (n = 5) ->
    sorted = @sort()
    sorted.slice(-n).reverse()

  randomInt: (lower, upper) ->
    [lower, upper] = [0, lower]     unless upper?           # Called with one argument
    [lower, upper] = [upper, lower] if lower > upper        # Lower must be less then upper
    Math.floor(Math.random() * (upper - lower + 1) + lower) # Last statement is a return value
    
  delay: (ms, func) ->
    setInterval func, ms

  randomFollowUp: (sender, msg) ->
      msg.reply "Ok @#{sender.mention_name}, you can let go now."

module.exports = (robot) ->
  wrhug = new WRHug robot
  allow_self = process.env.WR_HUG_ALLOW_SELF or "true"

  robot.hear /hug \@([^\s]+)/i, (msg) ->
    subject = msg.match[1]
    sender  = msg.message.user
    if allow_self is true or msg.message.user.name.toLowerCase() != subject
      wrhug.increment subject
      msg.send "@#{subject} #{wrhug.incrementResponse()} (#{subject} has #{wrhug.get(subject)} hug#{if wrhug.get(subject) > 1 then 's' else ''})"
      int = wrhug.randomInt(1, 4)
      if `int == 2`
        setTimeout () ->
          msg.send msg.random wrhug.dropResponses(sender, subject) 
        , 15000
    else
      msg.send msg.random wrhug.selfDeniedResponses(msg.message.user.name)

  # robot.hear /(\S+[^-:\s])[: ]*--(\s|$)/, (msg) ->
  #   subject = msg.match[1].toLowerCase()
  #   if allow_self is true or msg.message.user.name.toLowerCase() != subject
  #     wrhug.decrement subject
  #     msg.send "#{subject} #{wrhug.decrementResponse()} (wrhug: #{wrhug.get(subject)})"
  #   else
  #     msg.send msg.random wrhug.selfDeniedResponses(msg.message.user.name)


#   hubot hug empty <thing> - empty a thing's hugs
  # robot.respond /hug empty @?([\w .\-_]+)/, (msg) ->
  #   subject = msg.match[1].toLowerCase()
  #   if allow_self is true or msg.message.user.name.toLowerCase() != subject
  #     wrhug.kill subject
  #     msg.send "#{subject} has had its hugs scattered to the winds."
  #   else
  #     msg.send msg.random wrhug.selfDeniedResponses(msg.message.user.name)

  robot.respond /hug most$/i, (msg) ->
    verbiage = ["Most hugged"]
    for item, rank in wrhug.top()
      verbiage.push "#{rank + 1}. #{item.name} - #{item.wrhug}"
    msg.send verbiage.join("\n")

  robot.respond /hug least$/i, (msg) ->
    verbiage = ["Least hugged"]
    for item, rank in wrhug.bottom()
      verbiage.push "#{rank + 1}. #{item.name} - #{item.wrhug}"
    msg.send verbiage.join("\n")

  robot.respond /hug show \@([^\s]+)/i, (msg) ->
    match = msg.match[1]
    if match != "best" && match != "worst"
      msg.send "@#{match} has #{wrhug.get(match)} hug#{if wrhug.get(match) > 1 then 's' else ''}."

 # robot.respond /hug grouphug$/i, (msg) ->
 #   verbiage = ["Group hug"]
 #   subject = "@all"
 #   wrhug.increment subject
 #   msg.send "#{subject} #{wrhug.incrementResponse()} (WRHug: #{wrhug.get(subject)})"

  # robot.respond /hug (\S+[^-\s])$/i, (msg) ->
  #   match = msg.match[1].toLowerCase()
  #   if match != "best" && match != "worst"
  #     msg.send "\"#{match}\" has #{wrhug.get(match)} hugs."
