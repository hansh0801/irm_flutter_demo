import 'japiRequest.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'irm_auth.dart';

//ignore_for_file: non_constant_identifier_names

///인자로 받은 그룹의 환자 정보 리스트를 반환
///input: group_id
///output: groups' patient list
Future<List> getPatientList(group_id) async {
  var queryParameters = {
    'vgroup_key_list': '{"$group_id"}',
  };
  var jsonResult = await getPatientSearch(queryParameters);

  return jsonResult['patient_list'];
}

///자신이 속한 그룹의 이름 리스트를 반환
///input: nothing
///output: my groups' list of name
Future<List> getGroupNameList() async {
  var jsonData = await getGroupSearchBelonged();
  List<String> groupList = [];
  for (var data in jsonData['records']) {
    groupList.add(data['vgroup_name']);
  }

  return groupList;
}

///인자로 받은 그룹의 환자 이름 리스트를 반환
///input: group_id
///output: list of patients' name in group
Future<List> getPatientNameList(group_id) async {
  var queryParameters = {
    'vgroup_key_list': '{$group_id}',
  };
  var jsonData = await getPatientSearch(queryParameters);
  List patientList = jsonData['patient_list'];
  List patientName = [];

  for (var name in patientList) {
    patientName.add(name['patient_name']);
  }

  return patientName;
}

///그룹 내 환자 이름 검색, 환자 정보 리스트 반환
///input: group_id, patient_name
///output: list of patients' key
Future<List> searchPatientName(group_id, patient_name) async {
  List result = [];
  var queryParameters = {
    'vgroup_key_list': '{$group_id}',
    'patient_name': '$patient_name'
  };
  Map patientList = await getPatientSearch(queryParameters);
  result = patientList['patient_list'];

  return result;
}

///환자 사진 정보 Image로 반환
///input: patient_key
///output: Image data(not base 64)
Future<Uint8List> getPatientPhoto(patient_key) async {
  var queryParameters = {
    'patient_key': '$patient_key',
    'photo_tag': 'main',
  };
  var jsonData = await getPatientGetPhoto(queryParameters);
  String encoded = jsonData['patient_photo'];
  Uint8List bytes = base64.decode(encoded);

  return bytes;
}

///환자 정보 수정
///input: patient's data
///output: json
Future putPatientData(patient_key, patient_name, patient_sex, patient_birth_dttm,
patient_phone, patient_address, patient_guardian) async{
  var queryParameters = {
    'patient_key' : '$patient_key',
    'patient_name' : '$patient_name',
    'patient_sex' : '$patient_sex', //무조건 M, F, O 여야함
    'patient_birth_dttm' : '$patient_birth_dttm',
    'patient_phone' : '$patient_phone',
    'patient_address' : '$patient_address',
    'patient_guardian' : '$patient_guardian',
  };


  var result = await putPatientUpdate(queryParameters);


  print('putPatientData $result');

  return result;
}


///환자 삭제
///input: patient_key LIST
///{"1234","123","235","456"}
Future delPatient(List patient_key) async{
  var result;
  String patientList = '{';
  patientList += patient_key.join(',');
  patientList += '}';

  var queryParameters = {
    'patient_key_list' : '$patientList',
    'permanent' : 'true',
    'cascade' : 'true'
  };

  result = await deletePatient(queryParameters);
  print(result);

  return result;
}

///DCM 스터디 목록 가져오기
///
///
Future dcmStudySearch({List vgroup_key_list, List author_user_key_list, patient_key, patient_id_value, patient_name,
  patient_sex, study_id, study_dttm_from, study_dttm_to, study_desc, patient_age,
  accession_no, modality_list, offset, limit, sort_by, sort_dir}) async {

  String vgroupKeyList = '';
  if(vgroup_key_list != null){
    vgroupKeyList = '{' + vgroup_key_list?.join(',') + '}';
  }

  String authorUserKeyList = '';
  if(author_user_key_list != null){
    authorUserKeyList = '{' + author_user_key_list?.join(',') + '}';
  }

  var userKey = await userLookup();
  print(userKey);

  String searchValue = '''[
      {"field" : "vgroup_key_list", "value": "{${currentgroupkey.vgroup_key}}"},
      {"field" : "user_key_list", "value":"{$userKey}"}]''';

  

  var queryParameters = {
    'search' : '$searchValue'
  };

  print('쿼리파라미터 $queryParameters');
  var result = await getDcmStudySearch(queryParameters);
 // print(result);

  return result;
}

///계정 정보 조회
///
///
Future userLookup() async{
  var result = await getUserLookup();
  print(result);

  return result['user']['user_key'];
}



































