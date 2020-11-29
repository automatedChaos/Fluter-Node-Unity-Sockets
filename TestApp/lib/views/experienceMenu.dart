import 'package:flutter/material.dart';
import 'package:winston/controllers/ExperienceListController.dart';
import 'package:provider/provider.dart';

class ExperienceMenu extends StatefulWidget {

  static const String routeName = '/experienceMenu';
  
  @override
  _ExperienceMenuState createState() => _ExperienceMenuState();
}

class _ExperienceMenuState extends State<ExperienceMenu> {

  ExperienceListController experienceList;
  
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => getData());
  }

  void getData () {
    print("Requesting the Experience list");
    experienceList.fetch();
  }

  @override
  Widget build(BuildContext context) {

    experienceList = Provider.of<ExperienceListController>(context);
    
    return Scaffold(
      appBar: AppBar(
      title: Text("Select Companion"),
      ),
    body:
      Consumer<ExperienceListController>(
        builder: (context, experienceList, child) {
          return ListView(
            children: experienceList.generateExperienceTiles()
          );
        }
      )
    );
  }
}
