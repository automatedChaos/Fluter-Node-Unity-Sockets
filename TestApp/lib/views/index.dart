import 'package:TestApp/controllers/GestureController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:TestApp/utils/theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

class IndexPage extends StatefulWidget {

  static const String routeName = '/indext';

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
      // appBar: AppBar(
      //   centerTitle: true,
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text("CRAB"),
      // ),
      body:
        Column(
          children: <Widget>[
            Visibility(
              visible: gestureController.connected,
              child: connectedLayout()
            ),

            Visibility(
              visible: !gestureController.connected,
              child: ConnectButton()
            )
          ],
        )
      ); 
  }


  Widget ConnectButton () {
    return Consumer<GestureController>(
      builder: (context, experience, child) {
        return 
          Container(
            decoration: BoxDecoration(color: Colors.blue),
            width: MediaQuery.of(context).size.width, 
            height: MediaQuery.of(context).size.height,
            child: Center(
              child:
                Container (
                  width: MediaQuery.of(context).size.width / 3, 
                  height: MediaQuery.of(context).size.width / 3,
                  child: RaisedButton(
                    color: Color(myTheme.accentColor.value),
                    child: Text("GO", 
                      style: TextStyle(fontSize: 90, color: Color(0xffffffff))
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width / 3),
                    ),
                    onPressed: () {
                      gestureController.initConnection();
                    },
                  )
                )
              )
            );
      }
    );
  }

  Widget connectedLayout () {
    return Consumer<GestureController>(
      builder: (context, experience, child) {
        return Row(                
          children: [
            
            Container(
              color: Color(0xffff0000),
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height, 
              child: Column(
                children: <Widget>[
                  Text(
                    "CLICK TO LOCATE CRAB",
                    style: TextStyle(
                      color: Color(0xffffffff),
                      fontSize: 24
                    ),),
                  Expanded(
                    child: Image.asset('assets/crab.png')
                  ),
                  
                  RaisedButton(
                    color: Color(myTheme.accentColor.value),
                    child: Text("STOP"),
                    onPressed: () {
                      gestureController.stopConnection();
                    },
                  )
                ]
              )
            ),
            
            Container(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height, 
              child: Column(
                children: <Widget>[
                  Text(
                    "SHAKE PHONE",
                    style: TextStyle(
                      fontSize: 24
                    )),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      
                      imageGrid()
                    
                    ]
                  )
                ]
              )
              
            )
          ]
        );
      }
    );
  }



  Widget imageGrid () {
    return Consumer<GestureController>(
      builder: (context, experience, child) {
        return 
        Container(
          width: 300,
          height: 300,
          child: 
          GridView.count(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            crossAxisCount: 3,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            children: <Widget>[
              Image.asset('white.png'),
              Opacity(
                opacity: gestureController.opacities[0],
                child: Image.asset('up.png'),
              ),
              Image.asset('white.png'),
              Opacity(
                opacity: gestureController.opacities[1],
                child: Image.asset('left.png'),
              ),
              Image.asset('white.png'),
              Opacity(
                opacity: gestureController.opacities[2],
                child: Image.asset('right.png'),
              ),
              Image.asset('white.png'),
              Opacity(
                opacity: gestureController.opacities[3],
                child: Image.asset('down.png'),
              ),
              Image.asset('white.png'),
            ],
          )
        );
    });
  }
}
