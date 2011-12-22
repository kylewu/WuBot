module.exports =
	help : 'convert bug # to link'
	func : (bot) ->
		bot.all /bug\s*#?(\d+)/, (bot, room, from, text, match) ->
			console.log 'link: ' + match[0]
			bot.say room, 'http://bugzilla.mozilla.com.cn/show_bug.cgi?id=' + match[1]

		bot.privacy /bug\s*#?(\d+)/, (bot, from, text, match) ->
			console.log 'link: ' + match[0]

		return
