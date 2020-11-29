import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:winston/utils/ExperienceMenuItem.dart';
import 'package:winston/widgets/experienceTile.dart';
import 'package:winston/widgets/locationTile.dart';
import 'dart:convert';

class ExperienceListController extends ChangeNotifier {

  /// The url to fetch the menu list data from.
  String url = "http://167.172.54.123/api/public/all/experiences";

  /// The raw string data from the request response body
  String experienceMenuData;

  /// Flag used to check if the request was successful
  bool loadSuccess = false;

  /// flad used to check if the data has been processed correctly
  bool processSuccess = false;

  /// The final List of experiences once the data has been processed
  List<ExperienceMenuItem> experienceMenuItems;

  ExperienceListController () ;

  /// The initial request for data
  Future<void> fetch() async {

    Response response = await get(url);

    if (response.statusCode == 201){

      experienceMenuData = response.body;
      experienceMenuItems = processExperienceMenuData(this.experienceMenuData);
      loadSuccess = true;
      notifyListeners();
    }else{
      loadSuccess = false;
    }
  }
  
  List<ExperienceMenuItem> processExperienceMenuData(data){

    var experienceMenuJSON = jsonDecode(data);
    List<ExperienceMenuItem> experienceMenuItems = [];
    
    for (int i = 0; i < experienceMenuJSON.length; i++){
      ExperienceMenuItem item = ExperienceMenuItem.parseJsonObject(experienceMenuJSON[i]);
      experienceMenuItems.add(item);
    }
    
    processSuccess = true;
    return experienceMenuItems;
  }

  List<Widget> generateExperienceTiles(){

    List<Widget> widgetList = new List<Widget>();
    String currentLocation;

    //If the experienceMenuItems is not null
    if(experienceMenuItems != null){
      //for each experience
      for(int i = 0; i < experienceMenuItems.length; i++){
        //If it has variables
        if(experienceMenuItems[i].variables != null){
          //run through its variables
          for(int ii = 0; ii < experienceMenuItems[i].variables.length; ii++){
            //if there is a 'section:'
            if(experienceMenuItems[i].variables[ii].contains('section:')){
              //grab the other half of it - the value of the pair
              var subStrings = experienceMenuItems[i].variables[ii].split('section:');
              //if the value is not the current location
              if(subStrings[1] != currentLocation){
                //Add a new location tile with the name of the value to the widget list
                widgetList.add(new LocationTile(subStrings[1]));
                currentLocation = subStrings[1];
              }
              break;
            }
          }   
        }
        //Once we've checked for 'section:''s...
        //Add a new Experience Tile to the widget list containing the current Experience Menu Item
        widgetList.add(new ExperienceTile(experienceMenuItems[i]));
      }
    }
    print('returning');
    return widgetList;
  } 
}