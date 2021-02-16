import 'package:TestApp/controllers/GestureController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';


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
      DeviceOrientation.portraitUp
    ]);
  }

  @override
  Widget build(BuildContext context) {

    gestureController = Provider.of<GestureController>(context);
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("GESTURE DEMO"),
      ),
      body: 
        Consumer<GestureController>(
          builder: (context, experience, child) {
            return GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 8.0,
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
            );
        })
    );
  }
}
