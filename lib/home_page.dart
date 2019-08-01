import 'package:flutter/material.dart';
import 'irm_auth.dart';
import 'login_page.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'patients_info.dart';
import 'get_patient_data.dart';
import 'dart:io';
import "package:flutter/services.dart";
import 'drawer.dart';

class Home_Page extends StatefulWidget {



  @override
  _Home_PageState createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  Material myItems(
      IconData icon, String heading, int color, String navigateto) {
    return Material(
        color: Colors.white,
        elevation: 14.0,
        shadowColor: Color(0x802196F3),
        borderRadius: BorderRadius.circular(24.0),
        child: Center(
          child: InkWell(
            onTap: () {
              currentgroupkey =Group(patient_group["records"][0]["vgroup_key"], patient_group["records"][0]["vgroup_name"]);
                  Navigator.pushNamed(
                context,
                navigateto,
              );

            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            heading,
                            style: TextStyle(
                              color: new Color(color),
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                      Material(
                        color: new Color(color),
                        borderRadius: BorderRadius.circular(24.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(
                            icon,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    //home page layout
    {
      return WillPopScope(

        onWillPop: () {
          return showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Confirm Exit"),
                  content: Text("are you sure you want to exit?"),
                  actions: <Widget>[
                    new GestureDetector(
                      onTap: () => Navigator.of(context).pop(false),
                      child: roundedButton("No", const Color(0xff216bd6),
                          const Color(0xFFFFFFFF)),
                    ),
                    new GestureDetector(
                      onTap:  ()async => await SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                      child: roundedButton(" Yes ", const Color(0xff216bd6),
                          const Color(0xFFFFFFFF)),
                    ),

                  ],
                );
              });
        },
        child: new Scaffold(
          key: _key,
          appBar: new AppBar(
            title: new Text("IRM Test APP"),
            actions: <Widget>[
              new FlatButton(
                  child: new Text(
                    "logout",
                    style: new TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  onPressed: () {
                    logout();
                    Navigator.pop(context, true);
                  })
            ],
          ),
           drawer: buildDrawer(),
          body: new Container(
              child: StaggeredGridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            children: <Widget>[
              myItems(Icons.people, "patients", 0xffed622b, 'patients_info'),
              myItems(Icons.person_add, "new patient", 0xfffad610, 'new_patient'),
              myItems(Icons.format_list_bulleted, "make form", 0xff216bd6, 'make_form'),
              myItems(Icons.timeline, "Image Viewer", 0xff702670, 'image_viewer'),
              myItems(Icons.accessibility_new, "PhotoTest", 0xff201042, 'patient_photo'),
            ],
            staggeredTiles: [
              StaggeredTile.extent(2, 150.0),
              StaggeredTile.extent(1, 150.0),
              StaggeredTile.extent(1, 150.0),
              StaggeredTile.extent(2, 150.0),
              StaggeredTile.extent(1, 150),
            ],
          )),
        ),
      );
    }
  }
}


Widget roundedButton(String buttonLabel, Color bgColor, Color textColor) {
  var loginBtn = new Container(
    padding: EdgeInsets.all(5.0),
    alignment: FractionalOffset.center,
    decoration: new BoxDecoration(
      color: bgColor,
      borderRadius: new BorderRadius.all(const Radius.circular(10.0)),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: const Color(0xFF696969),
          offset: Offset(1.0, 6.0),
          blurRadius: 0.001,
        ),
      ],
    ),
    child: Text(
      buttonLabel,
      style: new TextStyle(
          color: textColor, fontSize: 20.0, fontWeight: FontWeight.bold),
    ),
  );
  return loginBtn;
}
