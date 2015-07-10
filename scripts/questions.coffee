# Description:
#   Holds all the questions of the world, and randomly asks members of a room to answer them.
#
# Commands:
#   hubot question blah blah blah - saves
#   hubot ask - asks a random question
#
# Examples:
#   hubot question what is the most embaressing thing you've ever done

module.exports = (robot) ->

  robot.respond /question (.*)$/i, (msg) ->
    question = msg.match[1].trim()
    questions = robot.brain.get('questions') or ""
    if questions.length is 0
      robot.brain.set questions: question
    else
      questions += "|" + question
      robot.brain.set questions: questions
    response = Math.floor(Math.random() * 6)
    if response == 0
      msg.send "Okie dokie you two, I got it!"
    else if response == 1
      msg.send "Oooooo, that is a fun one! Do you two ever take a break?"
    else if response == 2
      msg.send "Pffft, of course you would ask that, you are so typical!"
    else if response == 3
      msg.send "Awwwww, you two are adorbs."
    else if response == 4
      msg.send "Oh, I definitely want to be around when you two answer that doozy."
    else
      msg.send "You ask too many questions. So much blabbing!"

  robot.respond /ask$/i, (msg) ->
    questions = robot.brain.get('questions') or ""
    if questions.length is 0
      msg.send "I would love to, really, but I have nothing to ask. You did this to me."
    else
      qs = questions.split("|")
      qs_index = Math.floor(Math.random() * qs.length)
      question = qs[qs_index]
      msg.send question
      qs.splice(qs_index, 1);
      robot.brain.set questions: qs.join("|")