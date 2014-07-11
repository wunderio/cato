# Description:
#   Not now, Cato!
#
# Dependencies:
#   None
#
# Commands:
#   hubot cato quote - get a Cato quote
#   hubot cato image - get a Cato image
#
# Author:
#   Joe Baker


class WRCatoSurprise

  constructor: (@robot) ->
    @cache = {}

    @cato_images = [
      "http://i1.ytimg.com/vi/0eaLp2qs-Fk/maxresdefault.jpg",
      "http://i1.ytimg.com/vi/FbUD7FRStbY/maxresdefault.jpg",
      "http://i.imgur.com/foLvsf4.gif",
      "http://s.mcstatic.com/thumb/6432018/18273914/4/flash_player/0/1/trail_of_the_pink_panther_cato_attacks.jpg",
      "http://1.bp.blogspot.com/_UCuRAA28kIE/Sv1BCzKGK5I/AAAAAAAAAX4/m7KTNWe5gMY/s400/cato+attacks.jpg"
      "http://videos.videopress.com/nTOnJmF8/pink-panther-cato-attack_std.original.jpg",
      "http://www.dvdactive.com/images/reviews/screenshot/2003/11/pink_panther_collection_box_set_r2_03.jpg",
      "http://www.imfdb.org/images/thumb/2/28/PP6_01.jpg/600px-PP6_01.jpg",
      "http://1.bp.blogspot.com/-JGGGgD_pMHs/TsU911C2ntI/AAAAAAAAJuA/RUep-ikZAJs/s1600/pic113.png",
      "http://klipd.com/screenshots/3f6b3b87bc3a24e0c0bceda457628ba2-2.jpg",
      "http://1.bp.blogspot.com/-k35cLoPHPQQ/UV8SzA0vihI/AAAAAAAAX6E/LJE5l5As5JQ/s640/pink+1.jpg",
      "http://i.dailymail.co.uk/i/pix/2010/12/31/article-1342921-0C9CF8A0000005DC-454_468x349.jpg",
      "http://i.telegraph.co.uk/multimedia/archive/02406/pinkpanther1_2406759b.jpg",
      "http://movieactors.com/photos-stars/burt-kwouk-shotdark.jpg",
      "http://v007o.popscreen.com/eGhyNXNjMTI=_o_cato-and-clouseau-fight.jpg",
      "http://p2.storage.canalblog.com/23/60/659817/45439855.jpg",
      "http://www.classicmoviehub.com/blog/wp-content/uploads/2014/03/clouseaukarate2.jpg",
      "http://markblevis.com/wp-content/uploads/2012/09/CatoFong.jpg"
    ]

    @cato_quotes = [
      "Cato: Please, boss! I thought you were dead!\n
Clouseau: So as a tribute to my memory, you open this ... this Chinese nookie factory?\n
Cato: l had to do something to keep busy. Besides, a first-rate joint like this can make as much as three, four hundred thousand a year!'\n
Clouseau: Is that net?\n
Cato: No, gross.",
      "Saaaaaaaaaah!",
      "Clouseau: Cato! You imbecile, not now Cato!",
      "Cato: It's so obvious, it's bound to be a trap.\n
Clouseau: That is why you'll never be a great detective, Cato. It's so obvious that it could not possibly be a trap.",
      "Clouseau: Now, this time *I'm* going to stand on *your* shoulders!\n
Cato: What good will that do?\n
Clouseau: Because I'm taller than you are, you fool!",
      "Clouseau: But these aren't normal times. Cato. Someone just tried to kill me.\n
Cato: That's normal.\n
Clouseau: Ah, but this time, he thinks he had succeed.",
      "Clouseau: You fool! You raving Oriental idiot! There is a time and a place for everything, Cato! ... And this is it!",
      "Clouseau: You know, I am ashamed of myself, Cato. I forgot the first rule of self-defence. No matter what the circumstances, always anticipate the unexpected. Had you been a real assassin might have killed me. We're going to have to accelerate our training programme. You must learn to attack me whenever and wherever l least expect it and you must give no quarter. Understand?",
      "Clouseau: Argh! Cato, you fool. Get off of me, will you? Get off me! Cato, what are you doing? Not now. Cato! Release me, you fool!"
    ]

  catoImage: ->
    @cato_images[Math.floor(Math.random() * @cato_images.length)]

  catoQuote: ->
    @cato_quotes[Math.floor(Math.random() * @cato_quotes.length)]


module.exports = (robot) ->
  cato = new WRCatoSurprise robot

  robot.hear /./i, (msg) ->

    if Math.floor(Math.random() * 200) == 42
      setTimeout () ->
        msg.send cato.catoQuote()
      , 20000
    else if Math.floor(Math.random() * 200) == 142
      setTimeout() ->
        msg.send cato.catoImage()
      , 20000

  robot.hear /cato quote/i, (msg) ->
    msg.send cato.catoQuote()

  robot.hear /cato image/i, (msg) ->
    msg.send cato.catoImage()
