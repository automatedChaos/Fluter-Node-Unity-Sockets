import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:winston/models/Beacon.dart';
import 'package:winston/models/Content.dart';
import 'package:winston/models/Payload.dart';

class ExperienceLoader {
  
  String appDirectoryPath;
  String rawExperience;
  var data;
  bool loadSuccess = false;

  Future<void> fetch(url) async {
    // first get the path to store files
    Directory appDocDir = await getApplicationDocumentsDirectory();
    appDirectoryPath = appDocDir.path + '/assets';
    await new Directory(appDirectoryPath).create(recursive: true);
    
    // make the requese
    Response response = await get(url);
    print(response.statusCode);

    // process the results / or don't
    if (response.statusCode == 201){
      this.rawExperience = response.body;
      this.data = jsonDecode(this.rawExperience);
      this.loadSuccess = true;
    }else{
      this.loadSuccess = false;
    }
  }

  List<String> getInfo() {
    return [
      data['payload']['_id'],
      data['payload']['name'],
      data['payload']['description'],
      data['payload']['variables'][0]
    ];
  }

  List<Beacon> getBeacons() {
    return this.processBeacons(data['payload']['beacons']);
  }
   
  List<Payload> getPayloads() {
    return this.processPayloads(data['payload']['payloads']);
  }

  List<Beacon> processBeacons (List rawBeacons){

    List<Beacon> processedBeacons = [];

    for (num i = 0; i < rawBeacons.length; i++){
      Beacon b = new Beacon(
          rawBeacons[i]['name'],
          rawBeacons[i]['locationDescription'],
          rawBeacons[i]['uuid'],
          rawBeacons[i]['type'],
          rawBeacons[i]['_id']);

      processedBeacons.add(b);
    }
    return processedBeacons;
  }

  List<Payload> processPayloads(List rawPayloads){
    
    List<Payload> processedPayloads = [];

    for (num i = 0; i < rawPayloads.length; i++){
      Payload p = new Payload(
          rawPayloads[i]['_id'],
          rawPayloads[i]['title'],
          rawPayloads[i]['description'],
          rawPayloads[i]['tags']);
      print("ADD PAYLOAD");
      p.addContent(this.processContent(rawPayloads[i]['content']));
      processedPayloads.add(p);
    }
    return processedPayloads;
  }

  List<Content> processContent(contents){

    Content.appDirectoryPath = appDirectoryPath;

    print("DIRECTORY");
    print(appDirectoryPath);

    List<Content> payloadContents = new List();

    for (num i = 0; i < contents.length; i++){
      Content c = new Content(
          contents[i]['_id'],
          contents[i]['altText'],
          contents[i]['name'],
          contents[i]['key'],
          contents[i]['type'],
          false
      );
      print("adding content");
      payloadContents.add(c);
    }
    return payloadContents;
  }
}