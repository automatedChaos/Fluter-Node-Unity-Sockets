import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:TestApp/controllers/GestureController.dart';
import 'package:TestApp/views/index.dart';

void main() {
  
  runApp(MultiProvider(
    providers: [  
      ChangeNotifierProvider(
          create: (context) => new GestureController())
    ],
    child: MyApp(),
  ));
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gesture Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: IndexPage(),
      routes: <String, WidgetBuilder>{
        IndexPage.routeName: (context) => IndexPage(),
      },
    );
  }
}
