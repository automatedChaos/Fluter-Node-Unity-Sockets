import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:winston/controllers/ExperienceController.dart';
import 'package:provider/provider.dart';

class ExperienceSinglePage extends StatefulWidget {

  static const String routeName = '/ExperienceSingle';

  ExperienceSinglePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ExperienceSinglePageState createState() => _ExperienceSinglePageState();
}

class _ExperienceSinglePageState extends State<ExperienceSinglePage> {
  
  ExperienceController experienceController;
  bool downloaded = false;

  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => setExperienceInfo());
  }
  
  void setExperienceInfo(){
    
    // Check whether the id is a key in the local storage
    experienceController.isExperienceAvailable(experienceController.currentExperienceMenuItem.id)
      .then((result) => {
        setState(() {
          downloaded = true;
        })
        // USED TO TRIGGER DOWNLOAD if (result != null) launchExperience() else downloadExperience()
      })
      .catchError(print);
  }

  void downloadExperience () {
    experienceController.beginExperienceDownload(experienceController.currentExperienceMenuItem.id);
    experienceController.startDownloadTimer();
  }

  void deleteExperience () {
    experienceController.deleteExperience(experienceController.currentExperienceMenuItem.id);
  }

  @override
  Widget build(BuildContext context) {
    
    experienceController = Provider.of<ExperienceController>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(experienceController.currentExperienceMenuItem.name),
      ),
      body: Center(
       
        child: Column(
    
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 40, 8, 40),
              child: Text(
                experienceController.currentExperienceMenuItem.description,
              ),
            ),
            Text(
              experienceController.currentExperienceMenuItem.dateUpdated.toString(),
            ),
            Text(
              "Is downloaded: " + downloaded.toString(),
            ),
            Visibility (
              visible: downloaded,
              child: FlatButton(
                onPressed: downloadExperience,
                shape: 
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.black)
                  ),
                child: 
                  Text('DOWNLOAD EXPERIENCE',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    )
                  ) 
              )
            ),
            Visibility (
              visible: downloaded,
              child: FlatButton(
                onPressed: deleteExperience,
                shape: 
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.black)
                  ),
                child: 
                  Text('    DELETE EXPERIENCE    ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    )
                  ) 
              )
            ),
          ],
        ),
      ),
    );
  }
}
