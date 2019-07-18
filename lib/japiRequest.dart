import "package:http/http.dart" as http;
import 'dart:convert';
import 'dart:io';

final String serverUrl = 'https://xdsserver-dev.irm.kr/XDSServer/api';
final String url = 'xdsserver-dev.irm.kr';

///json 형태로 리턴

///
Future getGroupSearchBelonged(accessToken) async {
  var uri = Uri.http(
      url, '/XDSServer/api/vgroup_belonged.w2ui'); //, queryParameters);
  var ret;
  http.Response resp = await http.get(uri, headers: {
    'Accept': 'text/html',
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
  // ignore: missing_return
  }).then((response) {
    print(accessToken);
    ret = utf8.decode(response.bodyBytes);
  });

  return json.decode(ret);
}

Future getPatientSearch(accessToken, queryParameters) async {
  var uri = Uri.https(url, '/XDSServer/api/patient', queryParameters);
  var ret;
  http.Response resp = await http.get(
    uri,
    headers: {
      'Accept': 'text/html',
      'Authorization': 'Bearer $accessToken',
    },
  // ignore: missing_return
  ).then((response) {
    ret = utf8.decode(response.bodyBytes);
  });

  return json.decode(ret);
}

Future postPatientCreate(accessToken, queryParameters) async {
  var uri = Uri.https(url, '/XDSServer/api/patient');
  var ret;
  http.Response resp = await http.post(uri, headers: {
    'Accept': 'text/html',
    'Authorization': 'Bearer $accessToken',
  }, body: {
    queryParameters,
    /*'vgroup_key': '26906',
    "patient_id_value": "123qwe",
    "patient_name": "이름이름12313",
    "patient_sex": "M",
    "patient_birth_dttm": "2020-11-22T03:35:14",
    "patient_phone": "010-1234-5678",
    "patient_address": "주소123",
    "patient_guardian": "가디언",*/
  // ignore: missing_return
  }).then((response) {
    ret = utf8.decode(response.bodyBytes);
  });

  return json.decode(ret);
}

Future putPatientUpdate(accessToken, queryParameters) async {
  var uri = Uri.https(url, '/XDSServer/api/patient');
  var ret;
  http.Response resp = await http.put(uri, headers: {
    'Accept': 'text/html',
    'Authorization': 'Bearer $accessToken',
  // ignore: missing_return
  }, body: {
    queryParameters,
  }).then((response) {
    ret = utf8.decode(response.bodyBytes);
  });
  return json.decode(ret);
}

/// DELETE 는 json 형태가 아니라 statusCode 반환
Future deletePatient(accessToken, queryParameters) async {
  var uri = Uri.https(url, '/XDSServer/api/patient');

  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.deleteUrl(uri);
  request.headers.set('Authorization', 'Bearer $accessToken');
  request.headers.set('Content-Type', 'application/json');
  request.add(utf8.encode(json.encode(queryParameters)));

  HttpClientResponse response = await request.close();
  httpClient.close();

  return response.statusCode;
}

Future putPatientSetPhoto(accessToken, queryParameters) async {
  var uri = Uri.https(url, '/XDSServer/api/patient_photo');
  var ret;
  http.Response resp = await http.put(uri, headers: {
    'Accept': 'text/html',
    'Authorization': 'Bearer $accessToken',
  },
  body:{
    queryParameters,
  // ignore: missing_return
  }).then((response) {
    ret = utf8.decode(response.bodyBytes);
  });

  return json.decode(ret);
}

/// \/ -> /, /n -> 제거
Future getPatientGetPhoto(accessToken, queryParameters) async {
  var uri = Uri.https(url, '/XDSServer/api/patient_photo', queryParameters);
  var ret;
  http.Response resp = await http.get(uri, headers: {
    'Accept': 'text/html',
    'Authorization': 'Bearer $accessToken',
  // ignore: missing_return
  }).then((response) {
    ret = utf8.decode(response.bodyBytes);
  });

  ret = json.decode(ret);
  ret['patient_photo'] = ret['patient_photo'].toString().replaceAll('\/', '/').replaceAll('\n', '');

  return json.decode(ret);
}

/// DELETE 는 json 형태가 아니라 statusCode 반환
Future deletePatientRemovePhoto(accessToken, queryParameters) async {
  var uri = Uri.https(url, '/XDSServer/api/patient_photo');

  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.deleteUrl(uri);
  request.headers.set('Authorization', 'Bearer $accessToken');
  request.headers.set('Content-Type', 'application/json');
  request.add(utf8.encode(json.encode(queryParameters)));

  HttpClientResponse response = await request.close();
  httpClient.close();

  return response.statusCode;
}

Future putPatientPhoto(accessToken, queryParameters) async {
  var uri = Uri.https(url, '/XDSServer/api/patient_photo');
  var ret;
  http.Response resp = await http
      .put(
    uri,
    headers: {
      'Accept': 'text/html',
      'Authorization': 'Bearer $accessToken',
    },
    body: queryParameters,
  )
      // ignore: missing_return
      .then((response) {
    ret = utf8.decode(response.bodyBytes);
  });

  return json.decode(ret);
}