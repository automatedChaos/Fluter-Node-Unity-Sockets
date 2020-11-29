import 'package:flutter/material.dart';
import 'package:winston/utils/ExperienceMenuItem.dart';
import 'package:winston/controllers/ExperienceController.dart';
import 'package:winston/views/experienceSingle.dart';
import 'package:provider/provider.dart';

class ExperienceTile extends StatefulWidget{

  ExperienceMenuItem experienceMenuItem;
  ExperienceTile(this.experienceMenuItem);

  @override
  _ExperienceTileState createState() => _ExperienceTileState();
}

class _ExperienceTileState extends State<ExperienceTile>{
  
  bool downloaded = false;
  ExperienceController experienceController;

  //This is just a test to change the button state
  void buttonPress(){

    experienceController.currentExperienceMenuItem = widget.experienceMenuItem;
    Navigator.pushNamed(context, ExperienceSinglePage.routeName);

    // // Check whether the id is a key in the local storage
    // experienceController.isExperienceAvailable(widget.experienceMenuItem.id)
    //   .then((result) => {
    //     if (result != null) launchExperience() else downloadExperience()
    //   })
    //   .catchError(print);

    // // 
    // setState(() {
    //   downloaded = !downloaded;
    // });
  }

  void downloadExperience () {
    experienceController.beginExperienceDownload(widget.experienceMenuItem.id);
    experienceController.startDownloadTimer();
  }

  void launchExperience () {
    experienceController.loadExperienceFromLocalStorage(widget.experienceMenuItem.id);
  }

  @override
  Widget build(BuildContext context) {
    
    experienceController = Provider.of<ExperienceController>(context);
    
    return Container(
      padding: EdgeInsets.only(top:12, right: 14, bottom:12, left:14),
      decoration: BoxDecoration(
        border: Border(
          //top: BorderSide(color: Colors.grey, width: 1, style: BorderStyle.solid),
          bottom: BorderSide(color: Colors.grey, width: 1, style: BorderStyle.solid),
        ), 
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child:
          Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: 
                  Text(widget.experienceMenuItem.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                  )
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: 
                  Text(widget.experienceMenuItem.beacons.length.toString() + ' locations',
                  style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Color.fromARGB(255, 100, 100, 100),
                  fontSize: 16),
                  )
                ),
            ],
          ),
          ),
          //gets a different button depending on download status
          FlatButton(
            onPressed: buttonPress,
            shape: 
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.black)
              ),
            child: 
              Text('VIEW',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                )
              ) 
          )
        ]
      )
    );
  }
}