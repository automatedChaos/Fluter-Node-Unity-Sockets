import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:provider/provider.dart';
import 'package:winston/controllers/ExperienceController.dart';

class DownloadPage extends StatefulWidget {

  static const String routeName = '/download';

  DownloadPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  
  ExperienceController experienceController;

  void initState() {
    super.initState();
  }

  void scan() async {
    String cameraScanResult = await scanner.scan();
    print(cameraScanResult);
    
    String url = cameraScanResult;
    // experienceController.fetch(url); 
  }

  void dispose() {
    super.dispose();
  } 

  @override
  Widget build(BuildContext context) {

    experienceController = Provider.of<ExperienceController>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan and Download Experience"),
      ),
      body: new Column(
        children: <Widget>[
          Visibility(
            visible: false,
            child: Center(
              child: RaisedButton(
                onPressed: () {
                  this.scan();  // Navigate back to first route when tapped.
                },
                child: Container(
                  child: const Text(
                    'SCAN EXPERIENCE', style: TextStyle(fontSize: 20)
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: true,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column( 
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(height: 80),
                  Consumer<ExperienceController>(
                    builder: (context, experience, child) {
                      return Text(
                        experienceController.currentExperience.name,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Consumer<ExperienceController>(
                    builder: (context, poiModel, child) {
                      return Text(
                        experienceController.currentExperience.description
                      );
                    },
                  ),
                  SizedBox(height: 200),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          scan();
                        },
                        child: Text('SCAN', style: TextStyle(fontSize: 20)),
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => MapPage()),
                          // );
                        },
                        child: Text('START', style: TextStyle(fontSize: 20)),
                      ),
                    ]
                  ),
                ]
              ),
            ),
          ),
        ],
      ),
    );
  }
}
