import 'package:TestApp/controllers/GestureController.dart';
import 'package:TestApp/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartLayout extends StatefulWidget {
  final String path;

  const StartLayout({
    Key key,
    this.path
  }) : super(key: key);


  @override
  _StartLayoutState createState() => _StartLayoutState();
}

class _StartLayoutState extends State<StartLayout> {
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
}
