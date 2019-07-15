import 'package:flutter/material.dart';
import 'package:simple_auth/simple_auth.dart' as simpleAuth;
import 'package:simple_auth_flutter/simple_auth_flutter.dart';
import "package:http/http.dart" as http;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:alice/alice.dart';
import 'home_page.dart';

import 'irm_auth.dart';

Alice alice = Alice(showNotification: true); //notification 줘서 뭘 받는지 알 수 있게

class MainLoginPage extends StatefulWidget {
  @override
  _MainLoginPageState createState() => _MainLoginPageState();
}

class _MainLoginPageState extends State<MainLoginPage> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      //navigatorKey: alice.getNavigatorKey(),
      debugShowCheckedModeBanner: false,
      title: "IRM Test App",
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new LoginPage(),
    );
  }
}

final IRMAuth irmApi = new IRMAuth("FRONT-VL Dev04", "front-vl-dev04",
    "front-vl-dev04-secret", "http://localhost:8080");

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    SimpleAuthFlutter.init(context);

    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(title: new Text("IRM Test apk")),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
            child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: buildSubmitButtons(),
        )),
      ),
    );
  }

  Future<Null> login() async {
    final _token = await getToken();
    print("token is $_token");
  }

  List<Widget> buildSubmitButtons() {
    return [
      Image.asset(
        "images/sample.png",
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      ),
      SizedBox(
        height: 30.0,
      ),
      new RaisedButton(
          child: new Text(
            "login with IRM Account",
            style: new TextStyle(fontSize: 20.0),
          ),
          onPressed: () => login()),
      SizedBox(
        height: 5.0,
      ),
      new RaisedButton(
          child: new Text("alice"), onPressed: () => alice.showInspector()),
    ];
  }


  Future<Stream<String>> _server() async {
    final StreamController<String> onCode = new StreamController();
    HttpServer server =
        await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
    server.listen((HttpRequest request) async {
      final String code = request.uri.queryParameters["code"];
      request.response
        ..statusCode = 200
        ..headers.set("Content-Type", ContentType.html.mimeType)
        ..write("<html>You can now close this window</html>");
      await request.response.close();
      await server.close(force: true);
      onCode.add(code);
      await onCode.close();
    });
    return onCode.stream;
  }

  Future<Token> getToken() async {
    String url =
        'https://oauth2-dev.irm.kr/AuthServer/web/authorize?response_type=code&client_id=front-vl-dev04&redirect_uri=http%3A%2F%2Flocalhost%3A8080&scope=refreshToken&state=xyz';


    final FlutterWebviewPlugin webviewPlugin = new FlutterWebviewPlugin();
    webviewPlugin.launch(url /*, clearCache: true, clearCookies: true*/);
    Stream<String> onCode = await _server(); //
    final String code = await onCode.first;
    webviewPlugin.close();

    final http.Response response = await http.post(
      "https://oauth2-dev.irm.kr/AuthServer/rest/oauth2/token",
      headers: {
        'Accept': 'application/json',
        'Authorization':
            'Basic ZnJvbnQtdmwtZGV2MDQ6ZnJvbnQtdmwtZGV2MDQtc2VjcmV0',
        'Host': 'front-vl-dev.irm.kr',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: {
        "client_id": 'front-vl-dev04',
        "redirect_uri": "http://localhost:8080",
        "code": code,
        "grant_type": "authorization_code"
      },
    ).then((response) {
      alice.onHttpResponse(response);
      var token = json.decode(response.body);
      //showMessage(token["access_token"]);
      if (token["access_token"] != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
      print(token["access_token"]);
    });

    return new Token.fromMap(json.decode(response.body));
  }
}
