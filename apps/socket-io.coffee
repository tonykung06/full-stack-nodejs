module.exports = (server, app) ->
	socketIO = require('socket.io')(server)
	unless app.settings && app.settings.socketIO
		app.set 'socketIO', socketIO
	socketIO.sockets.on 'connection', (socket) ->
		console.log 'CONNECTED'