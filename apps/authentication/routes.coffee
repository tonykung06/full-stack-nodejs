routes = (app) ->
	app.get '/login', (req, res) ->
		res.render "#{__dirname}/views/login",
			title: 'Login'
			stylesheet: 'login'

	app.post '/sessions', (req, res) ->
		if 'tony' is req.body.user and '12345' is req.body.password
			req.session.currentUser = req.body.user
			req.flash 'info', "You are logged in as #{req.session.currentUser}"
			res.redirect req.session.previousUrl || '/admin/pies123'
			return
		req.flash 'error', 'Those credentials were incorrect. Try again.'
		res.redirect '/login'

	app.del '/sessions', (req, res) ->
		req.session.regenerate (err) ->
			req.flash 'info', "You have been logged out." #this is not working as the flash is still stored in old session
			req.session.flash = [];
			req.session.flash.push({
				type: 'info',
				message: 'You have been logged out.'
			})
			res.redirect '/login'

module.exports = routes