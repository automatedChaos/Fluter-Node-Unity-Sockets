import 'Content.dart';
import 'dart:convert';

class Payload {

  String id;
  String title;
  String description;
  String tags;

  List<Content> content = new List();

  Payload(id, title, description, tags) {
    this.id = id;
    this.title = title;
    this.description = description;
    this.tags = tags;
  }

  void addContent(List<Content> content) {
    this.content = content;
  }

  Map toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'tags': tags,
    'content': generateContentString()
  };

  generateContentString() {
    
    String contentListString = "[";
    for (int i = 0; i < content.length; i++){

      Map contentMap = content[i].toJson();
      String contentString = json.encode(contentMap);

      contentListString += contentString;
      if (i != content.length -1 ) contentListString += ',';
    }
    contentListString += "]";
    
    return contentListString;
  }

  static List<Payload> jsonStringToList(String jsonString){
    List<Payload> payloadList = [];
    List<dynamic> dynamicList = json.decode(jsonString);    

    for (int i = 0; i < dynamicList.length; i++){
      Payload newPayload = Payload( // id, title, description, tags
        dynamicList[i]["id"], 
        dynamicList[i]["title"], 
        dynamicList[i]["decription"], 
        dynamicList[i]["tags"]
      );

      // add the content to the payload
      List<Content> contentList = Content.jsonStringToList(dynamicList[i]["content"]); 
      newPayload.addContent(contentList);
      payloadList.add(newPayload);
    }
    return payloadList;
  }

  double getDownloadProgress () {
    if (content.length > 0){  
      double total = 1;
      for (int i = 0; i < content.length; i++){
        total+= content[i].progress;
      }
      double mean = total / content.length;
      return mean;
    }else{
      return 100;
    }
  }

  void deleteContentFiles () {
    print("DELETE PAYLOAD");
    if (content.length > 0){  
      for (int i = 0; i < content.length; i++){
        content[i].deleteFile();
      }
    }
  }
}