http_client = require 'scoped-http-client'

http_client.create('http://baidu.com').get() (err, resp, body) ->
	console.log body
