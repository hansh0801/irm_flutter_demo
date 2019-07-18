import 'japiRequest.dart';
import 'dart:convert';
import 'irm_auth.dart';

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
Future<List> getGroupNameList() async{
  var jsonData = await getGroupSearchBelonged();
  List<String> groupList = [];
  for(var data in jsonData['records']){
    groupList.add(data['vgroup_name']);
  }

  return groupList;
}

///인자로 받은 그룹의 환자 이름 리스트를 반환
///input: group_id
///output: list of patients' name in group
Future<List> getPatientNameList(group_id) async{
  List patientGroup = await getPatientList(group_id);
  List<String> patientName = [];
  for(var name in patientGroup)
    patientName.add(name['patient_name']);

  return patientName;
}

///그룹 내 환자 이름 검색
///input: group_id, patient_name
///output: list of patients'name
Future<List> searchPatientName(group_id, patient_name) async {
  List<String> result = [];
  List<String> patientList = await getPatientNameList(group_id);

  for(String name in patientList){
    if(name.contains(patient_name))
      result.add(name);
  }

  return result;
}