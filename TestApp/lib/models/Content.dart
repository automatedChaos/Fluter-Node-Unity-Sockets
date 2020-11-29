import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

String store = "https://projectwave.ams3.digitaloceanspaces.com/content/"; // payload1595884879345

class Content {

  static Dio dio = Dio();
  static String appDirectoryPath; 

  String payloadID;
  String altText;
  String name;
  String key;
  String type;

  String localFilePath;
  bool downloaded = false;
  double progress = 0.0;

  Content(id, altText, name, key, type, downloaded) {
    
    // share this info with the rest of the content objects
    this.payloadID = id;
    this.altText = altText;
    this.name = name;
    this.key = key;
    this.type = type; 
    this.downloaded = downloaded;

    if (downloaded == false) downloadFile();
  }

  void downloadFile () {
    this.localFilePath = appDirectoryPath + '/' + this.key;
    download1(dio, store + this.key, localFilePath).then((value) => completeDownload());
  }

  Map toJson() => {
    'payloadID': payloadID,
    'altText': altText,
    'name': name,
    'key': key,
    'type': type,
    'downloaded': downloaded,
    'localFilePath': localFilePath
  };

  Future download1(Dio dio, String url, savePath) async {
    CancelToken cancelToken = CancelToken();
    try {
      await dio.download(url, savePath,
        onReceiveProgress: showDownloadProgress, cancelToken: cancelToken);
    } catch (e) {
      print(e);
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
      progress = (received / total * 100);
    }
  }

  void completeDownload() {
    print("DOWNLOAD COMPLETE");
    downloaded = true;
    progress = 100;
  }

  void deleteFile() {
    File file = new File(localFilePath);
    file.delete();
    print(localFilePath);
  }

  // convert a JSON string back to a list of Content objets
  static List<Content> jsonStringToList(String jsonString){
    List<Content> contentList = [];
    List<dynamic> dynamicList = json.decode(jsonString);    

    for (int i = 0; i < dynamicList.length; i++){
      Content newContent = Content( // id, altText, name, key, type
        dynamicList[i]["payloadID"], 
        dynamicList[i]["altText"],
        dynamicList[i]["name"], 
        dynamicList[i]["key"], 
        dynamicList[i]["type"],
        dynamicList[i]["downloaded"]
      );

      newContent.localFilePath = dynamicList[i]["localFilePath"];
      // add the content to the payload

      contentList.add(newContent);
    }
    return contentList;
  }
}