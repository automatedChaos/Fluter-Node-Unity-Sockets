// compute engine firewall: gcloud compute firewall-rules create allowws --network default --allow tcp:80

var WebSocketServer = require('websocket').server;
var http = require('http')

var unknowns = []
var players = []
var displays = []

var currentPlayerType = 0;

var webSocketPort = 8081

var server = http.createServer(function(request, response) { 
  console.log((new Date()) + ' Received request for ' + request.url);
  response.writeHead(404);
  response.end();
})

server.listen(webSocketPort, function() {
  console.log("Server is listening on port " + webSocketPort);
});

var wsServer = new WebSocketServer({
  httpServer: server
});

// ON CONNECTION
wsServer.on('request', function(request) {
 
  // ACCEPT AND RETURN ID  
  var connection = request.accept(null, request.origin); 

  let key = request.key;

  unknowns[key] = connection;
  connection.sendUTF(JSON.stringify({'action':'new-connection', 'data': key, 'key': key}));

  console.log("NEW CONNECTION")

  // MESSAGE RECEIVED
  connection.on('message', function(data) {
    console.log(data)
    payload = JSON.parse(data.utf8Data)
    directPayload(payload)
  });

  // CONNECTION CLOSE
  connection.on('close', function(connection) {
    
    // check if play. If so, remove from displays
    if (players[key] !== undefined)
      broadcastTo(newPayload(key, 'player-stop', payload.key), displays)

    delete unknowns[key]
    delete players[key]
    delete displays[key]
    
    console.log("DISCONNECTED: " + key)
    displayQueueStates()
  }.bind(key))
});

// channel the payload depending on the action type
function directPayload (payload) {
  switch (payload.action) {
    case 'register':
      registerClient (payload)
      break
    case 'player-position':
      broadcastTo(payload, displays)
      break
    case 'player-damage':
      addDamage(payload.data)
      break
    case 'player-complete':
      sendComplete(payload.data)
      break
  } 
}

// decide what type of client has just connected
function registerClient (payload) {
  switch (payload.data){
    case 'display': 
      switchArray(payload.key, unknowns, displays)
      initDisplay(payload.key)
      break
    case 'player':
      unknowns[payload.key].health = 100;
      switchArray(payload.key, unknowns, players)
      broadcastTo(newPayload(payload.key, 'player-start', payload.key), displays)
      broadcastTo(newPayload(payload.key, 'player-type', currentPlayerType), displays)
      directTo(newPayload(payload.key, 'player-type', currentPlayerType), players[payload.key])
      currentPlayerType++;
      if (currentPlayerType > 5) currentPlayerType = 0;
      break
    default: 
      console.log('Unknown Registration')
      break
  }
}

function initDisplay(displayKey) {
  for (var key in players) {
    directTo(newPayload(key, 'player-start', key), displays[displayKey])
  }
}

// send payload to single client
function directTo (payload, connection) {
  connection.sendUTF(JSON.stringify(payload))
}

// send payload to all clients of a certain type
function broadcastTo (payload, clientList) {
  for (var key in clientList) {
    clientList[key].sendUTF(JSON.stringify(payload));
  }
}

// move an item from one array to another
function switchArray (key, locationArray, destinationArray) {
  destinationArray[key] = locationArray[key]
  delete locationArray[key]
  displayQueueStates()
}

// A simple output for the client queue states
function displayQueueStates () {
  console.log(`UNKNOWNS:  ${Object.keys(unknowns).length} PLAYERS: ${Object.keys(players).length} DISPLAYS: ${Object.keys(displays).length}`)
}

// Quick factory for creating payloads
function newPayload (key, action, data) {
  return {
    key: key,
    action: action,
    data: data
  }
}

function addDamage(key) {
  if (players[key] && players[key].health > 0) {
    players[key].health-= 5
    directTo(newPayload(key, 'player-damage', players[key].health), players[key])
  }
}

function sendComplete(key) {
  console.log("COMPLETE: " + key)
  if (players[key]) {
    directTo(newPayload(key, 'player-complete', players[key].health), players[key])
  }
}

function Player(id, connection){
    this.id = id;
    this.connection = connection;
    this.name = "";
    this.opponentIndex = null;
    this.index = Players.length;
}

Player.prototype = {
    getId: function(){
        return {name: this.name, id: this.id};
    },
    setOpponent: function(id){
        var self = this;
        Players.forEach(function(player, index){
            if (player.id == id){
                self.opponentIndex = index;
                Players[index].opponentIndex = self.index;
                return false;
            }
        });
    }
};

// ---------------------------------------------------------
// Routine to broadcast the list of all players to everyone
// ---------------------------------------------------------
function BroadcastPlayersList(){
    var playersList = [];
    Players.forEach(function(player){
        if (player.name !== ''){
            playersList.push(player.getId());
        }
    });

    var message = JSON.stringify({
        'action': 'players_list',
        'data': playersList
    });

    Players.forEach(function(player){
        player.connection.sendUTF(message);
    });
}



  //   var message = JSON.parse(data.utf8Data);
    
  //   switch(message.action){

  //     case 'join':
  //       player.name = message.data;
  //       BroadcastPlayersList();
  //       break;

  //       case 'resign':
  //       console.log('resigned');
  //         Players[player.opponentIndex]
  //           .connection
  //           .sendUTF(JSON.stringify({'action':'resigned'}));

  //         setTimeout(function(){
  //           Players[player.opponentIndex].opponentIndex = player.opponentIndex = null;
  //         }, 0);
  //         break;

  //         case 'new_game':
  //           player.setOpponent(message.data);
  //           Players[player.opponentIndex]
  //             .connection
  //             .sendUTF(JSON.stringify({'action':'new_game', 'data': player.name}));
  //           break;

  //         case 'play':
  //           Players[player.opponentIndex]
  //             .connection
  //             .sendUTF(JSON.stringify({'action':'play', 'data': message.data}));
  //           break;
  //     }
