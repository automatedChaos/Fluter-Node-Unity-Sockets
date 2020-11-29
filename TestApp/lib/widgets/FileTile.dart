import 'package:flutter/material.dart';

class FileTile extends StatelessWidget{
  
final String name;

//This is shorthand for a simple constructor
FileTile(this.name);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(top:22, right: 14, bottom:22, left:14),
      color: Color.fromARGB(255, 220, 220, 220),
      child: Text('$name',
        style: TextStyle(
          fontSize: 20
        ),
      )
    );
  }
}