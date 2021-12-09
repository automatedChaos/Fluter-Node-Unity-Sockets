import 'dart:typed_data';
import 'package:TestApp/controllers/GestureController.dart';
import 'package:TestApp/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:io';
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
    // GlobalKey previewContainer = new GlobalKey();

    return Consumer<GestureController>(builder: (context, experience, child) {
      return RepaintBoundary(
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
}
