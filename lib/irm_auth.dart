import 'package:simple_auth/simple_auth.dart';
import "package:http/http.dart" as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'japiRequest.dart';

Token token = Token("", "", 0, ""); //token declaration and init
bool token_exist = false;

User_Info userinfo = User_Info("", ""); //for get userinfo using Oauth

var patient_group;
Group currentgroupkey ;

class IRMAuth extends OAuthApi {
  IRMAuth(String identifier, String clientId, String clientSecret,
      String redirectUrl,
      {List<String> scopes,
      http.Client client,
      Converter converter,
      AuthStorage authStorage})
      : super(
            identifier,
            clientId,
            clientSecret,
            "https://front-vl-dev.irm.kr/AuthServer/rest/oauth2/token",
            "https://front-vl-dev.irm.kr/AuthServer/web/authorize",
            redirectUrl,
            client: client,
            scopes: scopes,
            converter: converter,
            authStorage: authStorage) {
    this.scopes = scopes ?? ["basic"];
  }
}



Future<Stream<String>> server() async {
  final StreamController<String> onCode = new StreamController();
  HttpServer server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
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

Future<User_Info> getUserInfo() async {
  //getuserinfo

  final http.Response userinforesponse = await http.post(
    "https://oauth2-dev.irm.kr/AuthServer/rest/oauth2/introspect",
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Basic ZnJvbnQtdmwtZGV2MDQ6ZnJvbnQtdmwtZGV2MDQtc2VjcmV0',
      'Host': 'front-vl-dev.irm.kr',
      'Content-Type': 'application/x-www-form-urlencoded'
    },
    body: {"token": token.access_token, "token_type_hint": "access_token"},
  ).then((userinforesponse) {
    var temp_userinfo = json.decode(userinforesponse.body);

    userinfo = User_Info(temp_userinfo['client_id'], temp_userinfo['username']);

    print(userinfo.client_id);
    print(userinfo.username);
  });

  return null;
}

Future<Null> logout() async {
  //for logout

  token = Token("", "", 0, "");
}

void getGroupinfo() async {
  patient_group = await getGroupSearchBelonged();
}


class Token {
  final String access_token;
  final String token_type;
  final num expires_In;
  final String authCode;

  Token(this.access_token, this.token_type, this.expires_In, this.authCode);

  Token.fromMap(Map<String, dynamic> json)
      : access_token = json['access_token'],
        token_type = json['token_type'],
        expires_In = json['expires_in'],
        authCode = json['authcode'];
}

class User_Info {
  final String client_id;
  final String username;

  User_Info(this.username, this.client_id);
  User_Info.fromMap(Map<String, dynamic> json)
      : client_id = json["client_id"],
        username = json["username"];
}



class Patientlist{
   int vgroup_key;
   int patient_key;
   String patient_id_value;
    String patient_name;
   String patient_sex;
   String patient_birth_dttm;
   String patient_phone;
  String patient_address;
  String patient_guardian;


  Patientlist(this.vgroup_key,this.patient_key,this.patient_id_value,this.patient_name,this.patient_sex,this.patient_address,
      this.patient_birth_dttm,this.patient_guardian,this.patient_phone);



}

class Group{
  final int vgroup_key;
  final String vgroup_name;

  Group(this.vgroup_key,this.vgroup_name);
  @override
  String toString() => "vgroup_key is $vgroup_key , vgroup name os $vgroup_name ";

}