class ExperienceMenuItem {

  String name;
  String description;
  List<String> variables;
  List<String> beacons;
  List<String> payloads;
  String id;
  DateTime dateCreated;
  DateTime dateUpdated;
  int version;

  ExperienceMenuItem (
    String name, 
    String description, 
    List<String> variables,
    List<String> beacons, 
    List<String> payloads, 
    String id, 
    DateTime dateCreated, 
    DateTime dateUpdated, 
    int version
    ) {
    
    this.name = name;
    this.description = description;
    this.variables = variables;
    this.beacons = beacons;
    this.payloads = payloads;
    this.id = id;
    this.dateCreated = dateCreated;
    this.dateUpdated = dateUpdated;
    this.version = version;
  }

  /// A basic factory for creating ExperienceMenuItems from a JSON Object
  static ExperienceMenuItem parseJsonObject(object){

    ExperienceMenuItem experienceMenuItem = 
      new ExperienceMenuItem(
        object["name"], 
        object["description"], 
        unpackJSONArray(object["variables"]), 
        unpackJSONArray(object["beacons"]), 
        unpackJSONArray(object["payloads"]), 
        object["_id"], 
        DateTime.parse(object["createdAt"]), 
        DateTime.parse(object["updatedAt"]), 
        object["__v"]
      ); 
          
    return experienceMenuItem;
  }

  /// Convert a JSON string array into a List<String>
  static List<String> unpackJSONArray(array){
    List<String> strings = [];
    for (int i = 0; i < array.length; i++){
      strings.add(array[i]);
    }
    return strings;
  }
}