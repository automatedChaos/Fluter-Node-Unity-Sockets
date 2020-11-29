import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:winston/utils/ExperienceLoader.dart';
import 'package:winston/models/Experience.dart';
import 'package:winston/models/Beacon.dart';
import 'package:winston/models/Payload.dart';
import 'package:winston/utils/ExperienceMenuItem.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geodesy/geodesy.dart' as geo;


class ExperienceController extends ChangeNotifier {

  static final ExperienceController _instance = ExperienceController._internal();
  static final String server = "http://167.172.54.123/api/public/";
  
  Experience currentExperience = Experience("", "", "", "");
  BitmapDescriptor _markerIcon;

  ExperienceMenuItem currentExperienceMenuItem = ExperienceMenuItem("", "", [], [], [], "", new DateTime.now(), new DateTime.now(), 0);

  Timer downloadTimer; 

  factory ExperienceController() {
    return _instance;
  }
  
  ExperienceController._internal();

  isExperienceAvailable(String id) async {
    // attempt to pull experience from local storage
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    // localStorage.remove(id);
    String experience = localStorage.getString(id);

    return experience;
  }

  void beginExperienceDownload(String id) async {
    print("DOWNLOAD: " + id);
    
    // remove old data
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove(id);
    
    startDownloadTimer();
    ExperienceLoader experienceLoader = ExperienceLoader();
    await experienceLoader.fetch(server + id);
    
    List<String> info = experienceLoader.getInfo();
    
    // create a new Experience based on the data from the server
    currentExperience = Experience(info[0], info[1], info[2], info[3]);
    currentExperience.setBeacons(experienceLoader.getBeacons());
    currentExperience.setPayloads(experienceLoader.getPayloads());

    saveExperienceToLocalStorage(currentExperience);
    notifyListeners();
  }

  void deleteExperience (String id) async {

    loadExperienceFromLocalStorage(id);
    currentExperience.deletePayloadsFile();
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove(id);

  }

  static saveExperienceToLocalStorage (Experience experience) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    
    print("----------- SAVE -----------");
    Map<dynamic, dynamic> experienceMap = experience.toJson();
    String experienceString = json.encode(experienceMap);
    localStorage.setString(experience.id, experienceString);
  }

  Future<void> loadExperienceFromLocalStorage(String id) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String experienceString = localStorage.getString(id);

    Map experienceMap = json.decode(experienceString);
    
    currentExperience = Experience(
      experienceMap["id"],
      experienceMap["name"],
      experienceMap["description"],
      experienceMap["variables"]
    );
    
    currentExperience.setBeacons( Beacon.jsonStringToList(experienceMap["beacons"]));
    currentExperience.setPayloads( Payload.jsonStringToList(experienceMap["payloads"]));

    notifyListeners();
  }

  void startDownloadTimer () {
    print("DOWNLOAD PROGRESS TIMER");
    //if (downloadTimer.isActive) downloadTimer.cancel();
    downloadTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      double progress = currentExperience.getDownloadProgress();
      if (progress > 100){
        print("EXPERIENCE DOWNLOAD COMPLETE");
        timer.cancel();
        saveExperienceToLocalStorage(currentExperience);
      }
    });
  }

    Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if (_markerIcon == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size.square(98));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/images/pin.png')
          .then(_updateBitmap);
    }
  }

  void _updateBitmap(BitmapDescriptor bitmap) {
    _markerIcon = bitmap;
    notifyListeners();
  }

  Set<Marker> getMarkers (context) {
    _createMarkerImageFromAsset(context);
    if (currentExperience.beacons.length == 0) return null;
    Set<Marker> markers = new Set<Marker>();
    
    int count = 0;

    for (Beacon beacon in currentExperience.beacons) {
      count++;

      if (beacon.type == "GPS"){
        Marker m = new Marker(
          markerId: MarkerId("index-" + count.toString()),
          position: new LatLng(beacon.lat, beacon.lng),
          icon: _markerIcon,
        );
        markers.add(m);
      }
    }
 
    return markers;
  }
}