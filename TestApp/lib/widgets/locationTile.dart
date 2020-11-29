import 'package:flutter/material.dart';

class LocationTile extends StatelessWidget{
  
final String name;

//This is shorthand for a simple constructor
LocationTile(this.name);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(top:22, right: 14, bottom:22, left:14),
      color: Color.fromARGB(255, 220, 220, 220),
      child: Column(
        children: <Widget>[
          //Image(image: AssetImage('$name')),
          Text('$name',
            style: TextStyle(
            fontSize: 20
          ),
        )
        ],
      )
      
      
      
    );
  }
}