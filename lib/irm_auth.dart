import "package:http/http.dart" as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'japiRequest.dart';

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types

Token token = Token("", "", 0, ""); //token declaration and init
User_Info userinfo = User_Info("", ""); //for get userinfo using Oauth
var patient_group;
Group currentgroupkey;

Future<Stream<String>> server() async {
  final StreamController<String> onCode = new StreamController();
  HttpServer server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  server.listen((HttpRequest request) async {
    final String code = request.uri.queryParameters["code"];
    request.response
      ..statusCode = 200
      ..headers.set("Content-Type", ContentType.html.mimeType);
    await request.response.close();
    await server.close(force: true);
    onCode.add(code);
    await onCode.close();
  });
  return onCode.stream;
}

Future<User_Info> getUserInfo() async {
  final http.Response userinforesponse = await http.post(
    "https://oauth2-dev.irm.kr/AuthServer/rest/oauth2/introspect",
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Basic ZnJvbnQtdmwtZGV2MDQ6ZnJvbnQtdmwtZGV2MDQtc2VjcmV0',
      'Host': 'front-vl-dev.irm.kr',
      'Content-Type': 'application/x-www-form-urlencoded'
    },
    body: {"token": token.access_token, "token_type_hint": "access_token"},
  );
    var temp_userinfo = json.decode(userinforesponse.body);
    userinfo = User_Info(temp_userinfo['client_id'], temp_userinfo['username']);

    print(userinfo.client_id);
    print(userinfo.username);

  return null;
}

Future refreshToken() async {
  ///https://oauth2-dev.irm.kr/AuthServer/rest/oauth2/token
  var uri = Uri.https('oauth2-dev.irm.kr', '/AuthServer/rest/oauth2/token');

  http.Response resp = await http.post(uri, headers: {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Authorization': 'Basic ZnJvbnQtdmwtZGV2MDQ6ZnJvbnQtdmwtZGV2MDQtc2VjcmV0',
  }, body: {
    'grant_type': 'refresh_token',
    'refresh_token': '${token.refresh_token}',
  });

  print('refresh ${resp.statusCode}');

  var data = json.decode(resp.body);

  token = Token(data['access_token'], data['token_type'], data['expires_in'],
      data['refresh_token']);

  print('token refreshed');
  print('access_token: ${token.access_token}');
  print('refresh_token: ${token.refresh_token}');
  Timer(Duration(seconds: token.expires_in), refreshToken);
}

Future<Null> logout() async {
  token = Token("", "", 0, "");
}

void getGroupinfo() async => patient_group = await getGroupSearchBelonged();
class Token {
  final String access_token;
  final String token_type;
  final num expires_in;
  final String refresh_token;

  Token(this.access_token, this.token_type, this.expires_in, this.refresh_token);

  Token.fromMap(Map<String, dynamic> json)
      : access_token = json['access_token'],
        token_type = json['token_type'],
        expires_in = json['expires_in'],
        refresh_token = json['refresh_token'];
}

class User_Info {
  final String client_id;
  final String username;

  User_Info(this.username, this.client_id);
  User_Info.fromMap(Map<String, dynamic> json)
      : client_id = json["client_id"],
        username = json["username"];
}

class Patientlist {
  int vgroup_key;
  int patient_key;
  String patient_id_value;
  String patient_name;
  String patient_sex;
  String patient_birth_dttm;
  String patient_phone;
  String patient_address;
  String patient_guardian;

  Patientlist(
      this.vgroup_key,
      this.patient_key,
      this.patient_id_value,
      this.patient_name,
      this.patient_sex,
      this.patient_address,
      this.patient_birth_dttm,
      this.patient_guardian,
      this.patient_phone);
}

class Group {
  final int vgroup_key;
  final String vgroup_name;

  Group(this.vgroup_key, this.vgroup_name);
  @override
  String toString() =>
      "vgroup_key is $vgroup_key , vgroup name os $vgroup_name ";
}
