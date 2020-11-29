import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/drawer.dart';
import 'package:winston/controllers/ExperienceController.dart';
import 'package:winston/controllers/NavigationController.dart';
import 'package:winston/utils/style.dart';
import 'package:winston/views/payload.dart';

class MapPage extends StatefulWidget {

  static const String routeName = '/map';

  MapPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  
  GoogleMapController mapController;
  ExperienceController experienceController;
  NavigationController navigationController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  
  @override
  Widget build(BuildContext context) {
    
    navigationController = Provider.of<NavigationController>(context);
    experienceController = Provider.of<ExperienceController>(context);

    LatLng prevLocation;

    this.navigationController.addListener(() {
      
      LatLng newLocation = this.navigationController.currentLocation;

      if (mapController != null && newLocation != prevLocation){
        mapController.moveCamera(
          CameraUpdate.newLatLng(
            newLocation
          ),
        );
      }
      prevLocation = newLocation;
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Consumer<ExperienceController>(
          builder: (context, poiModel, child) {
            return Text(
              experienceController.currentExperience.name,
              textAlign: TextAlign.center,
              style: Style.headerStyle,
            );
          }
        ),
      ),
      drawer: buildDrawer(context, MapPage.routeName),
      body: Container( 
        margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            
            Expanded(
              child: Stack(
                children: <Widget>[
                  Consumer<ExperienceController>(
                    builder: (context, poiModel, child) {
                      return GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: _kGooglePlex,
                        onMapCreated: _onMapCreated,
                        rotateGesturesEnabled: true,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        markers: experienceController.getMarkers(context)
                      );
                    }
                  ),
                  
                  Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                        child: Consumer<ExperienceController>(
                          builder: (context, poiModel, child) {
                            return Text(
                              experienceController.currentExperience.description,
                              textAlign: TextAlign.center,
                              style: Style.bodyStyle,
                            );
                          },
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.pushNamed(context, PayloadPage.routeName);
                        },
                        child: Text(
                          "Payload",
                        ),
                      ),
                    ],
                  ),
                ],
              ) 
  
            )
          ] 
        ),
      ),
    );
  }
}
