import 'dart:convert';

class Beacon {

  String name;
  String locationDescription;
  String uuid;
  String type;
  String id;

  double lat;
  double lng;
  double accuracy;

  bool found = false;


  Beacon(name, locationDescription, uuid, type, id) {
    this.id = id;
    this.name = name;
    this.locationDescription = locationDescription;
    this.uuid = uuid;
    this.type = type;

    if (type == "GPS") this.processGPS();
  }

  Map toJson() => {
    'id': id,
    'name': name,
    'locationDescription': locationDescription,
    'uuid': uuid,
    'type': type,
    'found': found,
    'lat': lat,
    'lng': lng
  };

  void processGPS() {
    List values = this.uuid.split(',');
    if (values.length >= 3) {
      this.lat = double.parse(values[0]);
      this.lng = double.parse(values[1]);
      this.accuracy = double.parse(values[2]);
    }
  }

  static List<Beacon> jsonStringToList(String jsonString){
    List<Beacon> beaconList = [];
    List<dynamic> dynamicList = json.decode(jsonString);    

    for (int i = 0; i < dynamicList.length; i++){
      Beacon newBeacon = Beacon(
        dynamicList[i]["name"], 
        dynamicList[i]["locationDescription"], 
        dynamicList[i]["uuid"], 
        dynamicList[i]["type"], 
        dynamicList[i]["id"]
      );

      beaconList.add(newBeacon);
    }

    return beaconList;
  }
}