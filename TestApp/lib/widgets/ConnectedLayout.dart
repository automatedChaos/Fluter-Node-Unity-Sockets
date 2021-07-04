import 'package:TestApp/controllers/GestureController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:TestApp/utils/theme.dart';

class ConnectedLayout extends StatefulWidget {
  final String path;

  const ConnectedLayout({
    Key key,
    this.path
  }) : super(key: key);


  @override
  _ConnectedLayoutState createState() => _ConnectedLayoutState();
}

class _ConnectedLayoutState extends State<ConnectedLayout> {
  GestureController gestureController;
  @override
  initState() { 
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    gestureController = Provider.of<GestureController>(context);

    return Consumer<GestureController>(
      builder: (context, experience, child) {
        return Row(                
          children: [
            
            Container(
              //color: Color(0xffff0000),
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height, 
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/background.png'),
                ),
              ),
              child: 
                Stack(children: <Widget>[
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: 
                          Padding(
                            padding: EdgeInsets.fromLTRB(100, 90, 100, 0),
                            child: Image.asset('assets/crab' + gestureController.playerType.toString() + '.png')
                          )
                      ),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child:
                            SizedBox(
                              width: 150.0,
                              child:
                              RaisedButton(
                                color: Color(0xffff0000),
                                child: Text(
                                  "EXIT",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffffffff)
                                  ),
                                ),
                                onPressed: () {
                                  gestureController.stopConnection();
                                },
                              )
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child:
                            new SizedBox(
                              width: 150.0,
                              child:
                              RaisedButton(
                                color: Color(myTheme.accentColor.value),
                                child: Text(
                                  "LOCATE CRAB",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffffffff)
                                  ),
                                ),
                                onPressed: () {
                                  gestureController.sendLocate();
                                },
                              )
                            )
                          )
                        ],
                      )
                      
                    ]
                  ),
                  
                  Align(alignment: Alignment.topCenter,
                    child: 
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Chip(
                          label: Text("HEALTH: " + gestureController.playerHealth.toString()),
                        )
                    ),
                  )
                ]
              )           
            ),
            
            Container(
              color: Color(0xffffffff),
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height, 
              child: Column(
                children: <Widget>[

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
          Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 2.3,
                height: MediaQuery.of(context).size.height,
                child: 
                  Center(
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
                        Image.asset('shake.png'),
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
                    ),
                  )
                ),
            
              ]
          );
    });
  }
}
