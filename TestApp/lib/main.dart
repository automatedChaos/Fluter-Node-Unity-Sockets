import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winston/controllers/ExperienceController.dart'; 
import 'package:winston/controllers/ExperienceListController.dart';
import 'package:winston/controllers/NavigationController.dart';
import 'package:winston/views/map.dart';
import 'package:winston/views/about.dart';
import 'package:winston/views/payload.dart';
import 'package:winston/views/download.dart';
import 'package:winston/views/experienceMenu.dart';
import 'package:winston/views/files.dart';
import 'package:winston/views/experienceSingle.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context) => new ExperienceController()),
        ChangeNotifierProvider(builder: (context) => new NavigationController()),
        ChangeNotifierProvider(builder: (context) => new ExperienceListController())
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WinstonCMS Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MapPage(),
      routes: <String, WidgetBuilder>{
        AboutPage.routeName: (context) => AboutPage(),
        DownloadPage.routeName: (context) => DownloadPage(),
        PayloadPage.routeName: (context) => PayloadPage(),
        ExperienceMenu.routeName: (context) => ExperienceMenu(),
        FilesPage.routeName: (context) => FilesPage(),
        ExperienceSinglePage.routeName: (context) => ExperienceSinglePage(),
      },
    );
  }
}
