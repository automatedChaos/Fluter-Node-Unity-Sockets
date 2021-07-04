import 'package:TestApp/controllers/GestureController.dart';
import 'package:TestApp/widgets/ConnectedLayout.dart';
import 'package:TestApp/widgets/FinishLayout.dart';
import 'package:TestApp/widgets/StartLayout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';

class IndexPage extends StatefulWidget {

  static const String routeName = '/index';

  IndexPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  
  GestureController gestureController;
  

  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight
    ]);

    SystemChrome.setEnabledSystemUIOverlays([]) ;
    Wakelock.enable();
  }

  @override
  Widget build(BuildContext context) {

    gestureController = Provider.of<GestureController>(context);
    
    return Scaffold(
      body:
        Column(
          children: <Widget>[
            Visibility(
              visible: gestureController.connected && !gestureController.playerComplete,
              child: ConnectedLayout()
            ),

            Visibility(
              visible: !gestureController.connected && !gestureController.playerComplete,
              child: StartLayout()
            ),

            Visibility(
              visible: !gestureController.connected && gestureController.playerComplete,
              child: FinishLayout()
            )
          ],
        )
      ); 
  }
}
