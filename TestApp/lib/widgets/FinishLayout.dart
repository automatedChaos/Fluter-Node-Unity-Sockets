import 'dart:typed_data';
import 'package:TestApp/controllers/GestureController.dart';
import 'package:TestApp/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image/image.dart' as img; 
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';

class FinishLayout extends StatefulWidget {
  final String path;

  const FinishLayout({Key key, this.path}) : super(key: key);

  @override
  _FinishLayoutState createState() => _FinishLayoutState();
}

class _FinishLayoutState extends State<FinishLayout> {
  GestureController gestureController;
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    gestureController = Provider.of<GestureController>(context);
    GlobalKey previewContainer = new GlobalKey();

    Future<File> getImageFileFromAssets(String path) async {
      final byteData = await rootBundle.load('assets/$path');

      final file = File('${(await getTemporaryDirectory()).path}/$path');
      await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      return file;
    }

    // check for storage permissions
    Future<bool> _requestPermission(Permission permission) async {
      if (await permission.isGranted) {
        return true;
      } else {
        var result = await permission.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      }
      return false;
    }

    Future<bool> _save(int crabNumber, int health, int width, int height) async {
      print("SAVING");
      Directory directory;
      
      try {
        if (Platform.isAndroid){
          if (await _requestPermission(Permission.storage)) {
            directory = await getExternalStorageDirectory();
            String newPath = "";
            print(directory);
            List<String> paths = directory.path.split("/");
            for (int x = 1; x < paths.length; x++) {
              String folder = paths[x];
              if (folder != "Android") {
                newPath += "/" + folder;
              } else {
                break;
              }
            }
            newPath = newPath + "/RPSApp";
            directory = Directory(newPath);
          } else {
            return false;
          }
        } else {
          //IOS
          if (await _requestPermission(Permission.photos)) {
            directory = await getTemporaryDirectory();
          } else {
            return false;
          }
        }

        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

          // Create an image
        img.Image image = img.Image(width, height);
        
        // Fill it with a solid color (blue)
        img.fill(image, img.getColor(255, 255, 255));

        File bgFile = await getImageFileFromAssets('savebg.png');
        List<int> bgBytes = bgFile.readAsBytesSync();
        img.Image bgImage = img.decodeImage(bgBytes);

        double bgHeightScaleFactor = height / bgImage.height;
        img.drawImage(image, bgImage, dstX: 0, dstY: 0, dstW: (bgImage.width * bgHeightScaleFactor).toInt(), dstH: (bgImage.height * bgHeightScaleFactor).toInt());
        
        File crabFile = await getImageFileFromAssets('crab${crabNumber}.png');
        List<int> bytes = crabFile.readAsBytesSync();
        img.Image crabImage = img.decodeImage(bytes);
        
        double crabWidthScaleFactor = width / crabImage.width;
        // img.colorOffset(crabImage, alpha: 100);

        img.drawImage(image, crabImage, dstX: 0, dstY: height ~/ 5, dstW: (crabImage.width * crabWidthScaleFactor).toInt(), dstH: (crabImage.height * crabWidthScaleFactor).toInt());
        img.drawCircle(image, (width * .5).toInt(), (height * .15).toInt(), (width * .2).toInt(), img.getColor(45, 220, 45)); //(image, 0, 0, 320, 240, getColor(255, 0, 0), thickness: 3);
        
        // Draw some text using 24pt arial font
        img.drawString(image, img.arial_48, 600, 1200, 'Hello World');

        // await ImageGallerySaver.saveImage(Uint8List.fromList(img.encodePng(image)));
        final Uint8List finalImage = Uint8List.fromList(img.encodePng(image));

        final String dir = (await getApplicationDocumentsDirectory()).path;
        final String fullPath = '$dir/${DateTime.now().millisecond}.png';
        File capturedFile = File(fullPath);
        await capturedFile.writeAsBytes(finalImage);
        print(capturedFile.path);

        await GallerySaver.saveImage(capturedFile.path);


      } catch (e) {
        print('CRASH');
        print(e);
        return false;
      }
      return true;
    }

    void saveImage (BuildContext context) async {
      print("Attempting save");
      bool success = await _save(
        gestureController.playerType,
        gestureController.playerHealth,
        1200,
        1800
      );

      if (success) {
        _showDialog(context, "SUCCESS", "Your results have been saved as an image in the phones photo gallery");
      } else {
        _showDialog(context, "Error", "Unable to save your results to the phones local storage");
      }
    }

    return Consumer<GestureController>(builder: (context, experience, child) {
      return RepaintBoundary(
        key: previewContainer,
        child: Container(
            //color: Color(0xffff0000),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/background.png'),
              ),
            ),
            child: Stack(children: <Widget>[
              Column(children: <Widget>[
                Expanded(
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: Image.asset('assets/crab' +
                            gestureController.playerType.toString() +
                            '.png'))),
              ]),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Chip(
                      label: Text("HEALTH: " +
                          gestureController.playerHealth.toString()),
                    )),
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: RaisedButton(
                            color: Color(myTheme.accentColor.value),
                            child: Text("SAVE",
                                style: TextStyle(
                                    fontSize: 30, color: Color(0xffffffff))),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width / 3),
                            ),
                            onPressed: () {
                              saveImage(context);
                            },
                          )),
                      Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: RaisedButton(
                            color: Color(myTheme.accentColor.value),
                            child: Text("EXIT",
                                style: TextStyle(
                                    fontSize: 30, color: Color(0xffffffff))),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width / 3),
                            ),
                            onPressed: () {
                              gestureController.playerComplete = false;
                              gestureController.playerType = 0;
                            },
                          )),
                    ],
                  ))
            ])),
      );
    });
  }

  void _showDialog(BuildContext context, String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
