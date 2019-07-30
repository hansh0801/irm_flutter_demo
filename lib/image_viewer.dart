import 'package:flutter/material.dart';
import 'irm_auth.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:async';


class Image_Viewer extends StatefulWidget {
  @override
  _Image_ViewerState createState() => _Image_ViewerState();
}

class _Image_ViewerState extends State<Image_Viewer> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription<String> _onUrlChanged;


  @override

  void initState() {
    super.initState();
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        print("Current URL: $url");
        if(url == "https://bestimage-dev.irm.kr/m/m_subhtml/m_dicomview.html?user_key=&dcm_study_key=3584423&vgroup_key=37618&patient_id=CR_003") {
          print("Current URL: $url");
          //Navigator.pushNamed(context, "make_form");
        }
        //print("Current URL: $url");
      }
    });

  }

  @override
  void setState(fn) {
    // TODO: implement setState


  }


  void dispose() {
    _onUrlChanged.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: new AppBar(title: Text("image viewer"),),
      url: "https://bestimage-dev.irm.kr",
      withJavascript: true,

      withZoom: true,
      withLocalStorage: true,
      enableAppScheme: true,
      primary: true,
     // supportMultipleWindows: true,
      allowFileURLs: true,




    );
  }
}


