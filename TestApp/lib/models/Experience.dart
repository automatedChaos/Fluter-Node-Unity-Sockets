import 'dart:convert';
import 'package:winston/models/Beacon.dart';
import 'package:winston/models/Payload.dart';

class Experience {

  String id = '';
  String name = 'No Experience Loaded';
  String description = 'Go to the Download Page to scan a QR code and start a trail';
  String variables = '';

  List<Beacon> beacons = [];
  List<Payload> payloads = [];

  Experience (this.id, this.name, this.description, this.variables) ;

  void setBeacons (beacons){
    this.beacons = beacons;
  }

  void setPayloads (payloads) {
    // divide and conquer the contents 
    
    this.payloads = payloads;
  }

  Map toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'variables': variables,
    'beacons': generateBeaconString(),
    'payloads': generatePayloadString()
  };

  generateBeaconString() {
    String beaconListString = "[";
    for (int i = 0; i < beacons.length; i++){

      Map beaconMap = beacons[i].toJson();
      String beaconString = json.encode(beaconMap);

      beaconListString += beaconString;
      if (i != beacons.length -1 ) beaconListString += ',';
    }
    beaconListString += "]";
    
    return beaconListString;
  }

  generatePayloadString() {
    String payloadListString = "[";
    for (int i = 0; i < payloads.length; i++){

      Map payloadMap = payloads[i].toJson();
      String payloadString = json.encode(payloadMap);

      payloadListString += payloadString;
      if (i != beacons.length -1 ) payloadListString += ',';
    }
    payloadListString += "]";
    
    return payloadListString;
  }

  double getDownloadProgress () {
    double total = 0;
    for (int i = 0; i < payloads.length; i++){
      total+= payloads[i].getDownloadProgress();
    }
    return total / payloads.length;
  }

  Future<void> deletePayloadsFile () {
    if (payloads.length > 0){
      for (int i = 0; i < payloads.length; i++){
        payloads[i].deleteContentFiles();
      }
    }
  }
}