import 'package:flutter/material.dart';
import 'package:simple_auth/simple_auth.dart' as simpleAuth;
import 'package:simple_auth_flutter/simple_auth_flutter.dart';
import "package:http/http.dart" as http;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'home_page.dart';

import 'irm_auth.dart';

class MainLoginPage extends StatefulWidget {
  @override
  _MainLoginPageState createState() => _MainLoginPageState();
}

class _MainLoginPageState extends State<MainLoginPage> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      //navigatorKey: alice.getNavigatorKey(),
      debugShowCheckedModeBanner: false, //for keyboard layout error handling
      title: "IRM Test App",
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new LoginPage(),
    );
  }
}

final IRMAuth irmApi = new IRMAuth(
    "FRONT-VL Dev04",
    "front-vl-dev04",
    "front-vl-dev04-secret",
    "http://localhost:8080"); // for Oauth api information

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //GlobalObjectKey<ScaffoldState> _scaffoldKey;
  @override
  /*initState(){
    super.initState();
    _scaffoldKey = new GlobalObjectKey<ScaffoldState>(1);


  }*/
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      //appBar: new AppBar(title: new Text("IRM Test app")),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.stretch,

            children: buildSubmitButtons()),
//            buildSubmitButtons()
      ),
    );
  }

  Future<Null> login() async {
    //login
    await getToken();
    await getUserInfo();
    await getGroupinfo();

    print(token.access_token);
    // getUserInfo();

    Navigator.pushNamed(
      context,
      'home_page',
    );

    //print(token);
    //print(userinfo);
  }

  List<Widget> buildSubmitButtons() {
    //buildsubmitbuttons
    return [
      Image.asset(
        "images/irm_logo.png",
        width: 300,
        height: 100,
        //fit: BoxFit.cover,
      ),
      /*SizedBox(
        height: 30.0,
      ),*/
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

  Future<Token> getToken() async {
    //gettoken
    String url =
        'https://oauth2-dev.irm.kr/AuthServer/web/authorize?response_type=code&client_id=front-vl-dev04&redirect_uri=http%3A%2F%2Flocalhost%3A8080&scope=refreshToken&state=xyz';

    final FlutterWebviewPlugin webviewPlugin = new FlutterWebviewPlugin();
    webviewPlugin.launch(url /*, clearCache: true, clearCookies: true*/);
    print("not closed");
    Stream<String> onCode = await server(); //
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
    ).then((response) {
      var temp_token = json.decode(response.body);
      token = Token(temp_token['access_token'], temp_token['token_type'],
          temp_token['expires_in'], code);

      print('token is');
      print(token.access_token);
    });

    print(token.token_type);

    // return new Token.fromMap(json.decode(response.body));
  }
}
