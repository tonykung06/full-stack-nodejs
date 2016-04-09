assert = require 'assert'
redis = require('redis').createClient()
Pie = require '../../models/pie'

describe 'Pie', ->
	describe 'create', ->
		pie = null
		before (done) ->
			pie = new Pie {name: 'Key Lime'}
			done()
		it 'sets name', ->
			assert.equal pie.name, 'Key Lime'
		it 'defaults to some state', ->
			assert.equal pie.state, 'inactive'
		it 'generates id', ->
			assert.equal pie.id, 'Key-Lime'
	afterEach ->
		redis.del Pie.key()