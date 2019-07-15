import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import "package:irm_prototype1/login_page.dart";


void main() => runApp(new MaterialApp(home: SplashPage(),));


class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {

    return new SplashScreen(

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
