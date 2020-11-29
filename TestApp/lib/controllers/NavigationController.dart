import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class NavigationController extends ChangeNotifier {
  
  LatLng currentLocation = new LatLng(0,0);
  Location location = new Location();
  PermissionStatus _permissionGranted;
  bool _serviceEnabled;

  NavigationController(){
    this.initLocation();
  }

  void initLocation() async {
    
    this._serviceEnabled = await this.location.serviceEnabled();
    if (!this._serviceEnabled) {
      this. _serviceEnabled = await this.location.requestService();
      if (!this._serviceEnabled) {
        return;
      }
    }

    this._permissionGranted = await this.location.hasPermission();
    if (this._permissionGranted == PermissionStatus.denied) {
      this._permissionGranted = await this.location.requestPermission();
      if (this._permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    this.location.onLocationChanged.listen((LocationData newLocation) {
      this.currentLocation = new LatLng(newLocation.latitude, newLocation.longitude);
      notifyListeners();
    });
  }

  void stop() {
    this.location.onLocationChanged.listen(null);
  }
}