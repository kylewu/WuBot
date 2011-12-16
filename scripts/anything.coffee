Irc = require 'irc'

module.exports =


	help: 'anything'
	func: (bot) ->
		bot.all /.*/, (bot, from, text, match) ->
			console.log 'public text ', text
		
		bot.privacy /.*/, (bot, from, text, match) ->
			ans = Irc.colors.wrap 'yellow', 'are you hitting on me? Come on ~'
			bot.whisper from, ans
			console.log 'privacy text ', text
		return
