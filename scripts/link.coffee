module.exports =
	help : 'monitor a link'
	func : (bot) ->
		bot.all /http:\S+(?=\s|$)/, (bot, from, text, match) ->
			console.log 'link: ' + match[0]

		bot.privacy /http:\S+(?=\s|$)/, (bot, from, text, match) ->
			console.log 'link: ' + match[0]

		return
