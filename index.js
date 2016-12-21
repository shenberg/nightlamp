var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var path = require('path');
var fs = require('fs');
var bodyParser = require('body-parser');
var buffer = require('buffer');
var WebSocketServer = require('ws').Server;
var wss = WebSocketServer({port: 3001});

app.use(bodyParser.raw()); // for parsing application/octet-stream

var isWin = /^win/.test(process.platform);
var matlabPipe = undefined;
if (isWin) {
  var net = require('net');
  var pipePath = '\\\\.\\pipe\\nightpipe';
  var pipeServer = net.createServer(function(stream) {
    console.log('pipe listener connected');
    matlabPipe = stream;
    stream.on('end', function() {
      console.log('pipe listener disconnected');
      matlabPipe = undefined;
    });
  });
  //pipeServer.listen(pipePath);
  pipeServer.listen(5000);
}

app.get('/', function(req, res){
  res.sendFile('client.html', {root : __dirname});
});

app.get('/server', function(req, res){
  res.sendFile('server.html', {root : __dirname});
});

app.get('/server2', function(req, res){
  res.sendFile('raw_ws_server.html', {root : __dirname});
});

app.get('/buttonimg.jpg', function(req, res){
  res.sendFile('bttn_cntr.png',
   {root : __dirname+"/imgs"});
});

app.get('/sstest', function(req,res) {
  res.sendFile('out.png',{root: __dirname});
});

app.post('/save-image', function (req, res) {
  //console.log(req.body);
  var base64Encoded = req.body.slice(22); // skip data:img
  //console.log(base64Encoded.length);
  //console.log(buffer.transcode(base64Encoded,'base64','binary').length);
  //fs.writeFile('out.b64',base64Encoded,function (err) { console.log(err); });
  fs.writeFile('out.png',base64Encoded.toString(), 'base64', function (err) { console.log(err); });
  res.sendStatus(200);
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
  /*
  for(var userId in msgs) {
    if (msgs.hasOwnProperty(userId)) {
      var msg = msgs[userId];
      for(var i = 0; i < serverSockets.length; i++) {
        var server = serverSockets[i];
        server.emit("orientation", {x:msg[0],y:msg[1],touch:msg[2]});
      }
      
      totalMsg.push(userId + "," + msg[0] + "," + msg[1] + "," + msg[2]);
    }
  }*/
  for(var i = 0; i < serverSockets.length; i++) {
    var server = serverSockets[i];
    // TODO: validate
    //server.emit("orientations", msgs);
    server.volatile.emit("orientations", msgs);
  }

  if (totalMsg.length > 0) {
    if (matlabSocket) {
      matlabSocket.send(totalMsg.join("\n"));
    }
    if (matlabPipe) {
      matlabPipe.write(totalMsg.join("\n"));
    }
  }
  if (usersConnected > 0) {
    setTimeout(batchSend, 33);
  }
}

io.on('connection', function(socket){
  console.log('a user connected');
  usersConnected += 1;
  if (usersConnected == 1) {
    setTimeout(batchSend, 330);
  }

  socket.on('disconnect', function(){
  	if (!socket.isServer) {
      usersConnected -= 1;
	    console.log('user disconnected');
      var uid = socket.userId;
      if (uid !== undefined) {
        delete msgs[uid];
      }
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
    socket.userId = msg.user_id;
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

