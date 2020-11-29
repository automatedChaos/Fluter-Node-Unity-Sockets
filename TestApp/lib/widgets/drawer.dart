import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:winston/views/map.dart';
import 'package:winston/views/download.dart';
import 'package:winston/views/about.dart';
import 'package:winston/views/payload.dart';
import 'package:winston/views/experienceMenu.dart';
import 'package:winston/views/files.dart';

Drawer buildDrawer(BuildContext context, String currentRoute) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 40, 8, 10),
          child: SvgPicture.asset(
            'assets/svg/logo.svg',
            semanticsLabel: 'A red up arrow',
            width: 120,
          ),
        ),
        ListTile(
          title: const Text('MAP'),
          selected: currentRoute == MapPage.routeName,
          onTap: () {
            Navigator.pushReplacementNamed(context, MapPage.routeName);
          },
        ),
        ListTile(
          title: const Text('ABOUT'),
          selected: currentRoute == AboutPage.routeName,
          onTap: () {
            Navigator.pushNamed(context, AboutPage.routeName);
          },
        ),
        ListTile(
          title: const Text('DOWNLOAD LEG'),
          selected: currentRoute == DownloadPage.routeName,
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, DownloadPage.routeName);
          },
        ),
        ListTile(
          title: const Text('PAYLOAD'),
          selected: currentRoute == PayloadPage.routeName,
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, PayloadPage.routeName);
          },
        ),
        ListTile(
          title: const Text('DOWNLOAD'),
          selected: currentRoute == ExperienceMenu.routeName,
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, ExperienceMenu.routeName);
          }
        ),
        ListTile(
          title: const Text('FILES'),
          selected: currentRoute == FilesPage.routeName,
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, FilesPage.routeName);
          }
        ),
      ],
    ),
  );
}