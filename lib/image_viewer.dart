import 'package:flutter/material.dart';
import 'irm_auth.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class Image_Viewer extends StatefulWidget {
  @override
  _Image_ViewerState createState() => _Image_ViewerState();
}

class _Image_ViewerState extends State<Image_Viewer> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  bool flag = true;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription<String> _onUrlChanged;

  Future<String> evalJavascript(String code) async {
    final res = await _channel.invokeMethod('eval', {'code': code});
    return res;
  }

  final _channel = const MethodChannel('flutter_webview_plugin');


  @override
  void initState() {

    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      flag ? _getcookies() : null;
      if (mounted) {
        print("Current URL: $url");
        //Navigator.pushNamed(context, "make_form");
      }
      setState(() {
      });
    });

    print( _getcookies().toString());
    super.initState();

  }

  Future _getcookies() async{
    print("get cookies");

    await evalJavascript('document.cookie="Authority=manager"');
    await evalJavascript('document.cookie="bestimage_dev_access_token=${token.access_token}"');

    String cookiesString = await evalJavascript('document.cookie');
    print("just inserted cookie is");
    print(cookiesString.toString());
    await evalJavascript('location.reload();');
    flag = false;
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
     //url:'google.com',
       url: "https://bestimage-dev.irm.kr/m/m_main.html",
      withJavascript: true,
      //clearCache: true,
      //clearCookies: true,
      withZoom: true,
      withLocalStorage: true,
      enableAppScheme: true,
      primary: true,
      allowFileURLs: true,
    );
  }
}


