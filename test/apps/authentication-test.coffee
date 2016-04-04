assert = require 'assert'
request = require 'request'
server = require '../../bin/www'

describe "authentication", ->
	describe "GET /login", ->
		body = null
		before (done) ->
			makeRequest = ->
				options =
					uri: "http://localhost:#{process.env.PORT}/login"
				request options, (err, response, _body) ->
					body = _body
					done()

			if !server.listening
				server.on 'listening', makeRequest
			else
				makeRequest()
		it "has title", ->
			assert.hasTag body, '//head/title', 'Hot Pie - Login'
		it 'has user field', ->
			assert.hasTag body, "//input[@name='user']"
		it 'has password field', ->
			assert.hasTag body, "//input[@name='password']"

	describe 'POST /sessions', ->
		describe 'incorrect credentials', ->
			[body, response] = [null, null]

			before (done) ->
				login = ->
					request.post loginOptions, (err, _response, _body) ->
						[body, response] = [_body, _response]
						done()
				loginOptions =
					jar: true
					uri: "http://localhost:#{process.env.PORT}/sessions"
					form:
						user: 'incorrect user'
						password: 'incorrect password'
					followAllRedirects: true

				if !server.listening
					server.on 'listening', login
				else
					login()
				
			it 'show login error flash message', ->
				assert.hasTagMatch body, "//p" #damn, the xml2js-xpath sucks

		describe 'correct credentials', ->
			[body, response] = [null, null]

			before (done) ->
				login = ->
					request.post loginOptions, (err, _response, _body) ->
						[body, response] = [_body, _response]
						done()
				loginOptions =
					jar: true
					uri: "http://localhost:#{process.env.PORT}/sessions"
					form:
						user: 'tony'
						password: '12345'
					followAllRedirects: true

				if !server.listening
					server.on 'listening', login
				else
					login()
				
			it 'show logged in flash message', ->
				assert.hasTagMatch body, "//p" #damn, the xml2js-xpath sucks

	describe 'DELETE /sessions', ->
		[body, response] = [null, null]


		before (done) ->
			j = request.jar()

			login = ->
				request.post loginOptions, (err, _response, _body) ->
					logout()
			loginOptions =
				jar: j
				uri: "http://localhost:#{process.env.PORT}/sessions"
				form:
					user: 'tony'
					password: '12345'

			logout = ->
				request.del logoutOptions, (err, _response, _body) ->
					[body, response] = [_body, _response]
					done()
			logoutOptions =
				jar: j
				uri: "http://localhost:#{process.env.PORT}/sessions"
				followAllRedirects: true

			if !server.listening
				server.on 'listening', login
			else
				login()
				
		it 'show logged out flash message', ->
			assert.hasTagMatch body, "//p" #damn, the xml2js-xpath sucks
