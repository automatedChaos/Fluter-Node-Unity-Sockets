import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:winston/widgets/locationTile.dart';

class FilesPage extends StatefulWidget {

  static const String routeName = '/files';

  FilesPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FilesPageState createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  String path = '';
  List<String> fileList = [];
  List<Widget> listings = [];

  Future<void> _getPath() async {
    // first get the path to store files
    Directory appDocDir = await getApplicationDocumentsDirectory();
    setState(() {
      path = appDocDir.path + '/assets';
    });
  }

  Future<void> _getFiles() async {
    
    await _getPath();
    String appDirectoryPath = path;
    Directory assets = new Directory(appDirectoryPath);

    assets.list(recursive: true, followLinks: false)
      .listen((FileSystemEntity entity) {
        fileList.add(entity.path);
        _getListings();
      }); 
  }

  void _getListings() {
    
    List<Widget> listItems = [];

    if (fileList.length > 0){
      int i = 0;

      for (i = 0; i < fileList.length; i++) {
        listItems.add(
          LocationTile(
            fileList[i]
          ),
        );
        
      }
    }

    setState(() {
      listings = listItems;
    });
  }

  @override 
  void initState() {
    _getFiles();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("FILE LIST"),
      ),
      body: Center(
        child: Column(      
          children: <Widget>[
            Text(
              path,
            ),
            Expanded(
              child: SizedBox(
                height: 200.0,
                child: ListView(
                  padding: const EdgeInsets.all(1.0),
                  children: listings 
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
