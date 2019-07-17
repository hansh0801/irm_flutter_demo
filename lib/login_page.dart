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
      navigatorKey: alice.getNavigatorKey(),
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    SimpleAuthFlutter.init(context);

    return Scaffold(
      key: _scaffoldKey,
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
    if (token.access_token != "") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      await getToken();
    }

    //print(token);
    //print(userinfo);
  }

  Future<Null> logout() async {
    if (token.access_token != "") {
      token_exist = true;
      token = Token("", "", 0);
    } else {
      token_exist = false;
      print("no token");
    }
  }

  List<Widget> buildSubmitButtons() {
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
      new RaisedButton(
        child: new Text(
          "Log out",
          style: new TextStyle(fontSize: 20.0, color: Colors.white),
        ),
        onPressed: () {
          logout();
          final snackBar = SnackBar(
            content: token_exist
                ? Text('SucessFully logouted to IRM')
                : Text("you did not logined to IRM."),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );
          _scaffoldKey.currentState.showSnackBar(snackBar);
        },
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(20.0)),
        color: Colors.lightBlue,
      ),
    ];
  }

  Future<Token> getToken() async {
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
          temp_token['expires_in']);

      if (token.access_token != "") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
      //print('token is $token');
    });

    final http.Response userinforesponse = await http.post(
      "https://oauth2-dev.irm.kr/AuthServer/rest/oauth2/introspect",
      headers: {
        'Accept': 'application/json',
        'Authorization':
            'Basic ZnJvbnQtdmwtZGV2MDQ6ZnJvbnQtdmwtZGV2MDQtc2VjcmV0',
        'Host': 'front-vl-dev.irm.kr',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: {"token": token.access_token, "token_type_hint": "access_token"},
    ).then((userinforesponse) {
      var temp_userinfo = json.decode(userinforesponse.body);

      //alice.onHttpResponse(userinforesponse);

      userinfo = User_Info(
          code, temp_userinfo['client_id'], temp_userinfo['username']);
       print(userinfo.authCode);
       print(userinfo.client_id);
       print(userinfo.username);
    });

    return new Token.fromMap(json.decode(response.body));
  }
}
