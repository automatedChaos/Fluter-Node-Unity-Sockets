import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:winston/controllers/ExperienceController.dart';

class PayloadPage extends StatefulWidget {

  static const String routeName = '/payload';

  @override
  _PayloadPageState createState() => _PayloadPageState();
}

class _PayloadPageState extends State<PayloadPage> {
  ExperienceController experience;

  @override
  Widget build(BuildContext context) {
    
    this.experience = Provider.of<ExperienceController>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Payload"),
      ),
      
      body: Center(
       
        child: Column(
    
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 40, 8, 40),
              child: SvgPicture.asset(
                'assets/svg/logo.svg',
                semanticsLabel: 'A red up arrow',
                width: 120,
              ),
            ),
            Text(
              'PAYLOAD FOUND',
            ),
            // Consumer<ExperienceController>(
            //   builder: (context, poiModel, child) {
            //     return Text(
            //       ExperienceController.currentExperience. toString(),
            //       textAlign: TextAlign.center
            //     );
            //   },
            // ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Back",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
