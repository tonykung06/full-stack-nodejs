redis = require('redis').createClient()

class Pie
	@key: ->
		"Pie:#{process.env.NODE_ENV}"

	constructor: (attributes) ->
		@[key] = value for key, value of attributes
		@setDefaults()

	setDefaults: ->
		unless @state
			@state = 'inactive'
		@generateId()

	generateId: ->
		if not @id and @name
			@id = @name.replace /\s/g, '-'

	save: (callback) ->
		@generateId()
		redis.hset Pie.key(), @id, JSON.stringify(@), (err, code) =>
			callback null, @

module.exports = Pie