import 'japiRequest.dart';
import 'dart:convert';
import 'irm_auth.dart';

Future<List> getPatientList(group_id) async {
  var queryParameters = {
    'vgroup_key_list': '{"$group_id"}',
  };
  var jsonResult = await getPatientSearch(queryParameters);

  return jsonResult['patient_list'];
}

///이름만 들어있는 리스트 반환하는 함수
Future<List> getGroupNameList() async{
  var jsonData = await getGroupSearchBelonged();
  List<String> groupList = [];
  for(var data in jsonData['records']){
    groupList.add(data['vgroup_name']);
  }

  return groupList;
}