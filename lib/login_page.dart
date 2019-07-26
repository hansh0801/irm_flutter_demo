import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:async';
import 'dart:convert';
import 'irm_auth.dart';

class MainLoginPage extends StatefulWidget {
  @override
  _MainLoginPageState createState() => _MainLoginPageState();
}

class _MainLoginPageState extends State<MainLoginPage> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false, //for keyboard layout error handling
      title: "IRM Test App",
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buildSubmitButtons()),
      ),
    );
  }

  Future<Null> login() async {
    await getToken();
    await getUserInfo();
    getGroupinfo();

    Timer(Duration(seconds: token.expires_in), refreshToken);

    Navigator.pushNamed(
      context,
      'home_page',
    );
  }

  List<Widget> buildSubmitButtons() {
    return [
      Image.asset(
        "images/irm_logo.png",
        width: 300,
        height: 100,
      ),
      new RaisedButton(
        child: new Text(
          "login with IRM Account",
          style: new TextStyle(fontSize: 20.0, color: Colors.white),
        ),
        onPressed: () => login(),
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(20.0)),
        color: Colors.lightBlue,
      ),
      SizedBox(
        height: 5.0,
      ),
    ];
  }

  Future getToken() async {
    String url =
        'https://oauth2-dev.irm.kr/AuthServer/web/authorize?response_type=code&client_id=front-vl-dev04&redirect_uri=http%3A%2F%2Flocalhost%3A8080&scope=refreshToken';

    final FlutterWebviewPlugin webviewPlugin = new FlutterWebviewPlugin();
    webviewPlugin.launch(url /*, clearCache: true, clearCookies: true*/);
    print("not closed");
    Stream<String> onCode = await server();
    final String code = await onCode.first;

    webviewPlugin.close();
    print("closed");

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
    );

    var tempToken = json.decode(response.body);

    token = Token(tempToken['access_token'], tempToken['token_type'],
        tempToken['expires_in'], tempToken['refresh_token']);

    print('token is');
    print('access_token: ${token.access_token}');
    print('refresh_token: ${token.refresh_token}');

    print(token.token_type);
  }
}
