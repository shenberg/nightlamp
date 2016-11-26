var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var path = require('path');

app.get('/', function(req, res){
  res.sendFile('client.html', {root : __dirname});
});

app.get('/server', function(req, res){
  res.sendFile('server.html', {root : __dirname});
});


var serverSockets = [];

io.on('connection', function(socket){
  console.log('a user connected');
  socket.on('disconnect', function(){
  	if (!socket.isServer) {
	    console.log('user disconnected');
	} else {
		// socket is server socket
		serverSockets.splice(serverSockets.indexOf(socket), 1);
		console.log("server disconnected");
	}
  });
  socket.on("orientation", function(msg) {
  	console.log("got message: (" + msg.x + "," + msg.y + ")");
  	for(var i = 0; i < serverSockets.length; i++) {
  		var server = serverSockets[i];
  		server.emit("orientation", msg);
  	}
  });
  socket.on("server-started", function(msg) {
  	console.log("user is server!");
  	serverSockets.push(socket);
  	socket.isServer = true;
  });
});

http.listen(3000, function(){
  console.log('listening on *:3000');
});

