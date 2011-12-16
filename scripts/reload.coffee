module.exports =
	help : 'reload'
	func : (bot) ->
		bot.privacy /reload/, ((bot, from, text, match) ->
			bot.reload_scripts()
		), true
