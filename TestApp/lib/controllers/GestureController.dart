import 'dart:async';
import 'dart:convert';
import 'package:TestApp/utils/Payload.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

enum directions { 
  FORWARDS, 
  LEFT, 
  RIGHT, 
  DOWN 
}

class GestureController extends ChangeNotifier {

  // The unique identifier for this player
  String playerId = "NOT CONNECTED";
  
  // values for managing gestures. If active is true all over gesture inputs are blocked
  bool active = false;
  bool connected = false;

  List<double> opacities = [1, 1, 1, 1];

  // this is a game loop timer to allow for animations in opacity 
  Timer loopTimer;

  // TODO: Move into a method and allow user to connect and disconnect
  IOWebSocketChannel channel; 

  // Constructor
  void initConnection() {
    channel = IOWebSocketChannel.connect('ws://34.80.38.153:8081');
    initSocketEvents();
    initAccelerometer();
    startTimer ();
  }

  void stopConnection () {
    if (channel != null) channel.sink.close();
    //stopTimer();
  }

  // create the listeners for socket communication
  void initSocketEvents() {
    channel.stream.listen((event) {

      // grab the data from the incoming string
      Map<String, dynamic> payload = jsonDecode(event);
      
      // decide what action to take.
      switch (payload['action']) {
        case 'new-connection':
          initPlayer(payload['key']);
          break;
      }
    },
    // handle a server disconnect
    onDone: () {
      playerId = 'NOT CONNECTED';
      connected = false;
      notifyListeners();
    },
    // handle errors with connecting to the server
    onError: (error) {
      debugPrint('ws error $error');
    });
  }

  // when we receive the unique id from the server, we then need to tell
  // the server that this is a player.
  void initPlayer (String id) {
    
    // store the unique id for sending messages back to the server
    this.playerId = id;
    this.connected = true;

    // send the server a registration message
    Payload payload = new Payload('register', 'player', id);
    channel.sink.add(jsonEncode(payload));

    notifyListeners();
  }

  // Send player-position payloads. These will be sent to the Unity project and 
  // will be processed to update the players position
  void sendControl (String direction) {
    Payload payload = new Payload('player-position', direction, this.playerId);
    print(payload.data);
    channel.sink.add(jsonEncode(payload));
  }

  // Initialise the accelerometer listeners
  void initAccelerometer() {

    userAccelerometerEvents.listen((UserAccelerometerEvent event) { 
    
      //print(event);

      // TODO: Make the sensitivity an instance variable
      if (this.active != true){
        if (event.z  >  2)  {
          setActive(directions.FORWARDS.index);
          sendControl('0,1');
          return;
        }
        if (event.y < -1)  {
          setActive(directions.LEFT.index);
          sendControl('-1,0');
          return;
        }
        if (event.y > 1) {
          setActive(directions.RIGHT.index);
          sendControl('1,0');
          return;
        }
        if (event.z < -2) {
          print("DOWN");
          setActive(directions.DOWN.index);
          sendControl('0,-1');
          return;
        }
      }
    });
  }

  // Initialise the game loop - see if any control images are active
  // and reduce their opacity .1 every loop
  void startTimer () {
    loopTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      
      // print("TICK");
      for (int i = 0; i < opacities.length; i++){
        if (opacities[i] > .2) opacities[i] = opacities[i] - .1; 
      }
       
      this.notifyListeners();
    });
  }

  // TODO: Not utilised yet. Do we need this? 
  void stopTimer () {
    if (loopTimer != null) loopTimer.cancel();
  }

  // Sets active to true as a debounce. 
  // also updates the opacity to show which gesture has been activated
  void setActive (int direction) {
    this.active = true;
    this.opacities[direction] = 1;
    Timer(Duration(seconds: 1), () {
      setNotActive();  
    });
  }

  // set the gesture controller so it is ready to listen to gestures again.
  setNotActive () {
    this.active = false;
    print("READY");
  }
}