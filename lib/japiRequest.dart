import "package:http/http.dart" as http;
import 'dart:convert';
import 'dart:io';
import 'irm_auth.dart';

final String serverUrl = 'https://xdsserver-dev.irm.kr/XDSServer/api';
final String url = 'xdsserver-dev.irm.kr';

///json 형태로 리턴
Future getGroupSearchBelonged() async {
  var uri = Uri.http(
      url, '/XDSServer/api/vgroup_belonged.w2ui');
  http.Response resp;
  var ret;

  while(true){
    resp = await http.get(uri, headers: {
      'Accept': 'text/html',
      'Authorization': 'Bearer ${token.access_token}',
      'Content-Type': 'application/json',
    });

    if(resp.statusCode == 401){
      await refreshToken();
    }
    else{
      break;
    }
  }

  if(resp.statusCode != 200){
    return {};
  }

  ret = utf8.decode(resp.bodyBytes);

  return json.decode(ret);
}

///환자 검색
///    "vgroup_key_list" : "{30614,35729,26886,30700,31670}",
///    "patient_name" : "john",
///    "include_last_activity_dttm" : "true"
Future<Map> getPatientSearch(queryParameters) async {
  var uri = Uri.https(url, '/XDSServer/api/patient', queryParameters);
  http.Response resp;
  var ret;

  while(true){
    resp = await http.get(
      uri,
      headers: {
        'Accept': 'text/html',
        'Authorization': 'Bearer ${token.access_token}',
      },
    );

    if(resp.statusCode == 401){
      refreshToken();
    }
    else{
      break;
    }
  }

  if(resp.statusCode != 200){
    return {};
  }

  ret = utf8.decode(resp.bodyBytes);

  return json.decode(ret);
}

///환자 생성
///    "vgroup_key" : "30614",
///    "patient_id_value" : "P123",
///    "patient_name" : "PATIENT^NAME",
///    "patient_sex" : "M",
///    "patient_birth_dttm" : "2015-07-22T03:35:14",
///    "patient_phone" : "010-1234-5678",
///    "patient_address" : "somewhere",
///    "patient_guardian" : "God" 
///
///     status_code 반환
Future postPatientCreate(queryParameters) async {
  var uri = Uri.https(url, '/XDSServer/api/patient');
  http.Response resp = await http.post(uri, headers: {
    'Accept': 'text/html',
    'Content-Type' : 'application/x-www-form-urlencoded',
    'Authorization': 'Bearer ${token.access_token}',
  }, body:
    queryParameters,
  );

  return resp.statusCode;
}

///환자 수정
///    "patient_key" : "173326",
///    "patient_name" : "PATIENT^NAME",
///    "patient_sex" : "M",
///    "patient_birth_dttm" : "2015-07-22T03:35:14",
///    "patient_phone" : "010-1234-5678",
///    "patient_address" : "somewhere",
///    "patient_guardian" : "God" 
///   patient_key 대신에 vgroup_key, patient_id_value를 줄 경우
///   환자 수정 또는 생성
Future putPatientUpdate(queryParameters) async {
  var uri = Uri.https(url, '/XDSServer/api/patient');
  http.Response resp;
  var ret;

  while(true){
    resp = await http.put(uri, headers: {
      'Accept': 'text/html',
      'Authorization': 'Bearer ${token.access_token}',
    }, body:
    queryParameters,
    );

    if(resp.statusCode == 401){
      refreshToken();
    }
    else{
      break;
    }
  }

  if(resp.statusCode != 200){
    return {};
  }

  ret = utf8.decode(resp.bodyBytes);

  return json.decode(ret);
}


/// 환자 삭제
///    "patient_key_list" : "{153254}",
///    "permanent" : "true",
///    "cascade" : "true"
///
///     status_code 반환
Future deletePatient(queryParameters) async {
  var uri = Uri.https(url, '/XDSServer/api/patient');

  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.deleteUrl(uri);
  request.headers.set('Authorization', 'Bearer ${token.access_token}');
  request.headers.set('Content-Type', 'application/json');
  request.add(utf8.encode(json.encode(queryParameters)));

  HttpClientResponse response = await request.close();
  httpClient.close();

  return response.statusCode;
}

///환자 사진 등록
///patient_photo: base64 형식
///photo_tag 지정을 통해 여러 개의 사진 저장 가능
///    "my_user_key": "11994",
///    "patient_key" : "73418",
///    "patient_photo" : "MTIz",
///    "photo_tag" : "main"
Future putPatientSetPhoto(queryParameters) async {
  var uri = Uri.https(url, '/XDSServer/api/patient_photo');
  http.Response resp;
  var ret;

  while(true) {
    resp = await http.put(uri, headers: {
      'Accept': 'text/html',
      'Authorization': 'Bearer ${token.access_token}',
    }, body:
    queryParameters,
    );

    if(resp.statusCode == 401){
      refreshToken();
    }
    else{
      break;
    }
  }

  if(resp.statusCode != 200){
    return {};
  }

  ret = utf8.decode(resp.bodyBytes);

  return json.decode(ret);
}

/// 환자 사진 조회
/// base64 형식의 patient_photo 반환
///    "my_user_key": "11994",
///    "patient_key" : "73418",
///    "photo_tag" : "main"
Future getPatientGetPhoto(queryParameters) async {
  var uri = Uri.https(url, '/XDSServer/api/patient_photo', queryParameters);
  http.Response resp;
  var ret;

  while(true){
    resp = await http.get(uri, headers: {
      'Accept': 'text/html',
      'Authorization': 'Bearer ${token.access_token}',
    });

    if(resp.statusCode == 401){
      refreshToken();
    }
    else{
      break;
    }
  }

  if(resp.statusCode != 200){
    return {};
  }

  ret = utf8.decode(resp.bodyBytes);

  ret = json.decode(ret);
  ret['patient_photo'] = ret['patient_photo'].toString().replaceAll('\/', '/').replaceAll('\n', '');

  return ret;
}

/// 환자 사진 삭제
///    "my_user_key": "11994",
///    "patient_key" : "73418",
///    "photo_tag" : "main"
///
///     status_code 반환
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