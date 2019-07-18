import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import "package:irm_prototype1/login_page.dart";
import 'home_page.dart';
import 'patients_info.dart';
import 'new_patient.dart';
import 'make_form.dart';
import 'medical_record.dart';

void main() => runApp(new MaterialApp(
initialRoute: '/', // create initial route for each page
routes: {
  '/':(context) =>SplashPage(),
  ''
  'patients_info':(context)=>Patients_Info(),
  'new_patient':(context)=>New_Patient(),
  'medical_record':(context)=>Medical_Record(),
  'make_form':(context)=>Make_Form(),

  },
)
);


class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {

    return new SplashScreen( //loading screen

      seconds: 5,
      navigateAfterSeconds: new MainLoginPage(),
      title: new Text(
        "welcome to IRM App",
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      image: new Image.asset(
          "images/splashimage.gif"
      ),
      backgroundColor: Colors.white,
      loadingText: new Text("Loading now"),
      styleTextUnderTheLoader: new TextStyle( fontSize: 15.0, fontWeight: FontWeight.bold),
      photoSize: 200.0,
      onClick: () => print("flutter test"),
      loaderColor: Colors.blueAccent,
    );

  }
}
