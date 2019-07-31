import 'package:flutter/material.dart';
import 'irm_auth.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:async';
import "dart:ui";
import 'package:flutter/services.dart';
import 'dart:io';
import 'irm_auth.dart';

class Image_Viewer extends StatefulWidget {
  @override
  _Image_ViewerState createState() => _Image_ViewerState();
}

class _Image_ViewerState extends State<Image_Viewer> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription<String> _onUrlChanged;

  Future<String> evalJavascript(String code) async {
    final res = await _channel.invokeMethod('eval', {'code': code});
    return res;
  }

  final _channel = const MethodChannel('flutter_webview_plugin');


  @override

  void initState() {

     _getcookies();
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        print("Current URL: $url");
        if(url == "https://bestimage-dev.irm.kr/m/m_subhtml/m_dicomview.html?user_key=&dcm_study_key=3584423&vgroup_key=37618&patient_id=CR_003") {
          print("Current URL: $url");
          //Navigator.pushNamed(context, "make_form");
        }

      }
    });

    print( _getcookies().toString());
    super.initState();

  }
  Future _getcookies() async{
    print("hello1");


    await evalJavascript('document.cookie="Authority=manager"');
    await evalJavascript('document.cookie="bestimage_dev_access_token=${token.access_token}"');

    String cookiesString = await evalJavascript('document.cookie');
    print("just inserted cookie is");
    print(cookiesString.toString());
    setState(() {

    });


    /* final cookies = <String, String>{};
    if (cookiesString?.isNotEmpty == true) {
      cookiesString.split(';').forEach((String cookie) {
        final split = cookie.split('=');
        cookies[split[0]] = split[1];
      });
    }
    print(cookies);

    return cookies;*/





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
      appBar: new AppBar(title: Text("image viewer"), actions: <Widget>[
        IconButton(
          icon: new Icon(Icons.info),
          onPressed: (){ _getcookies(); },
        )

      ], ),
      url: "https://bestimage-dev.irm.kr/m/m_main.html",
      withJavascript: true,
      //clearCache: true,
      //clearCookies: true,

      withZoom: true,
      withLocalStorage: true,
      enableAppScheme: true,
      primary: true,
     // supportMultipleWindows: true,
      allowFileURLs: true,




    );
  }
}


