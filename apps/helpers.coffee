helpers = (app) ->
	app.locals.urlFor = (obj) ->
		if obj.id
			"/admin/pies/#{obj.id}"
		else
			"/admin/pies"

	app.locals.cssClassForState = (expected, actual) ->
		if actual is expected
			[expected, 'on']
		else
			expected

	app.locals.cssClassForPieAge = (pie) ->
		pieAge = (new Date).getTime() - pie.stateUpdatedAt
		minutes = (num) -> 1000 * 60 * num
		switch pie.state
			when 'making'
				if pieAge > minutes(1)
					'almost-ready'
				else
					'not-ready'
			when 'ready'
				if pieAge < minutes(1)
					'pipin-hot'
				else if pieAge < minutes(2)
					'hot'
				else
					'warm'

module.exports = helpers