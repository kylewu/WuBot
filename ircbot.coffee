Irc = require 'irc'
Fs = require 'fs'
Path = require 'path'

irc_server = 'irc.mozilla.org'
irc_rooms = ['#nodetest',]
#moz_room = '#mozilla_cn'
#irc_server = 'irc.freenode.net'
#irc_rooms = ['#ubuntu-cn',]

admins = ['wwu', 'wenbin']

# IRC API http://node-irc.readthedocs.org/en/latest/API.html
# Node.js http://nodejs.org/docs/latest/api/
class IRCBot
	constructor: (name='wbot', path='./scripts') ->
		@name = name
		@path = path
		@pub_listeners = []
		@pri_listeners = []
		@bot
		@admins = admins
		@n_retry = 3

	run : ->
		# import scripts
		@load_scripts @path

		# start bot without joining IRC
		@bot = new Irc.Client irc_server, @name, realName: 'MozBot', autoConnect: false, debug: true, showErrors: true

		# Add listener
		@bot.addListener 'message', (nick, room, message) =>
			# leave private message to pm listener
			if room == @name
				return
			##### to is #roomname

			console.log 'from ' + nick + ' room ' + room + ' message ' + message

			for lsn in @pub_listeners
				try
					lsn.handle @, message, nick, room
				catch ex
					console.error "error occurs when handler message #{ex}"

		@bot.addListener 'pm', (nick, message) =>

			console.log 'private message to me'
			for lsn in @pri_listeners
				try
					lsn.handle @, message, nick
				catch ex
					console.error "error occurs when handler message #{ex}"

		console.log 'connecting to ' + irc_server
		# connect IRC
		@bot.connect @n_retry, =>
			console.log 'successfully connected to IRC server'
			# join rooms
			for room in irc_rooms
				@bot.join room


	# Speak to all
	say : (room, text) ->
		@bot.say room, text
	
	# Response to someone
	whisper : (to, text) ->
		@bot.say to, text
	
	# Listen from somebody
	privacy : (regx, callback, admin=false) ->
		console.log ('new privacy ' + regx)
		lsn = new Listener(regx, callback, admin)
		@pri_listeners.push lsn
	
	# Listen from all
	all : (regx, callback, admin=false) ->
		console.log ('new listen ' + regx)
		lsn = new Listener(regx, callback, admin)
		@pub_listeners.push lsn

	# Load sripts in a folder
	load_scripts : (folder) ->

		path = Path.normalize folder
		console.log 'loading scripts form ' + path
		Path.exists path, (exists) =>
			for file in Fs.readdirSync path
				ext = Path.extname file

				if ext == '.js'
					full = Path.join path, Path.basename(file, ext)
					script = require full
					require(full).func @ if script.func?
	
	reload_scripts : () ->
		@pub_listeners = []
		@pri_listeners = []
		@load_scripts @path

class Listener
	constructor: (@regx, @callback, @admin) ->
	
	handle: (bot, text, nick, room=null) ->
		if @admin and not (nick in bot.admins)
			console.log (from + ' tried admin cmd')
			return
		if match = text.match @regx
			if room?
				@callback bot, room, nick, text, match
			else
				@callback bot, nick, text, match

module.exports = IRCBot
