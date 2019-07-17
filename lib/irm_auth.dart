import 'package:simple_auth/simple_auth.dart';
import "package:http/http.dart" as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';


Token token=Token("", "", 0);
bool token_exist=false;

User_Info userinfo;


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

class Token {
  final String access_token;
  final String token_type;
  final num expires_In;

  Token(this.access_token, this.token_type, this.expires_In);

  Token.fromMap(Map<String, dynamic> json)
      : access_token = json['access_token'],
        token_type = json['token_type'],
        expires_In = json['expires_in'];





  }


class User_Info {
  final String authCode;
  final String client_id;
  final String username;

  User_Info(this.authCode, this.username, this.client_id);
  User_Info.fromMap(Map<String, dynamic> json)
      : authCode = json['authcode'],

        client_id = json["client_id"],
        username = json["username"];
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

