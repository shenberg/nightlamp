var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var path = require('path');
var fs = require('fs');
var WebSocketServer = require('ws').Server;
var wss = WebSocketServer({port: 3001});

app.get('/', function(req, res){
  res.sendFile('client.html', {root : __dirname});
});

app.get('/server', function(req, res){
  res.sendFile('server.html', {root : __dirname});
});

app.get('/server2', function(req, res){
  res.sendFile('raw_ws_server.html', {root : __dirname});
});

var serverSockets = [];

var matlabSocket = undefined;
wss.on('connection', function connection(ws) {
  console.log('got matlab connection');
  matlabSocket = ws;
  ws.on('close', function close() {
    console.log('terminated matlab connection')
    if (ws === matlabSocket) {
      matlabSocket = undefined;
    }
  });
});

var usersConnected=0;
var msgs = {}

function batchSend() {
  var totalMsg = [];
  for(var userId in msgs) {
    if (msgs.hasOwnProperty(userId)) {
      var msg = msgs[userId];
      for(var i = 0; i < serverSockets.length; i++) {
        var server = serverSockets[i];
        server.emit("orientation", {x:msg[0],y:msg[1],touch:msg[2]});
      }
      
      totalMsg.push(msg.user_id + "," + msg[0] + "," + msg[1] + "," + msg[2]);
    }
  }
  if (matlabSocket && (totalMsg.length > 0)) {
    matlabSocket.send(totalMsg.join("\n"));
  }
  if (usersConnected > 0) {
    setTimeout(batchSend, 33);
  }
}

io.on('connection', function(socket){
  console.log('a user connected');
  usersConnected += 1;
  if (usersConnected == 1) {
    setTimeout(batchSend, 33);
  }

  socket.on('disconnect', function(){
  	if (!socket.isServer) {
      usersConnected -= 1;
	    console.log('user disconnected');
  	} else {
  		// socket is server socket
  		serverSockets.splice(serverSockets.indexOf(socket), 1);
  		console.log("server disconnected");
  	}
  });
  socket.on("orientation", function(msg) {
  	//console.log(msg.user_id + ": (" + msg.x + "," + msg.y + "," + msg.touch + ")");
    // 
    /*
  	for(var i = 0; i < serverSockets.length; i++) {
  		var server = serverSockets[i];
  		server.emit("orientation", msg);
  	}
    
    if (matlabSocket) {
      matlabSocket.send(msg.user_id + "," + msg.x + "," + msg.y + "," + (+msg.touch));
    }*/
    msgs[msg.user_id] = [msg.x, msg.y, msg.touch];
  });
  socket.on("server-started", function(msg) {
    usersConnected -= 1;
  	console.log("user is server!");
  	serverSockets.push(socket);
  	socket.isServer = true;
  });
});

http.listen(3000, function(){
  console.log('listening on *:3000');
});

