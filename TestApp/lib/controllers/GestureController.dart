import 'dart:async';
import 'dart:ffi'; 
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

enum directions { 
  FORWARDS, 
  LEFT, 
  RIGHT, 
  DOWN 
}

class GestureController extends ChangeNotifier {

  bool active = false;


  List<double> opacities = [1, 1, 1, 1];

  Timer loopTimer;

  GestureController () {

    userAccelerometerEvents.listen((UserAccelerometerEvent event) {

      if (this.active != true){
        if (event.z > 5)  {
          setActive(directions.FORWARDS.index);
          return;
        }
        if (event.x > 5)  {
          setActive(directions.LEFT.index);
          return;
        }
        if (event.x < -3) {
          setActive(directions.RIGHT.index);
          return;
        }
        if (event.z < -4) {
          setActive(directions.DOWN.index);
          return;
        }
      }
    });

    startTimer ();
  }

  void startTimer () {
    loopTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      print("TICK");
      for (int i = 0; i < opacities.length; i++){
        if (opacities[i] > .2) opacities[i] = opacities[i] - .1; 
      }

      this.notifyListeners();
    });
  }

  void stopTimer () {
    if (loopTimer != null) loopTimer.cancel();
  }

  void setActive (int direction) {
    this.active = true;
    this.opacities[direction] = 1;
    Timer(Duration(seconds: 1), () {
      setNotActive();  

    });
  }

  

  setNotActive () {
    this.active = false;
    print("READY");
  }
}