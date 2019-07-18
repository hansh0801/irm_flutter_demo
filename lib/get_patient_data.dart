import 'japiRequest.dart';
import 'dart:convert';
import 'irm_auth.dart';

getPatientList(group_id) async {
  var queryParameters = {
    'vgroup_key_list': '{"$group_id"}',
  };
  var jsonResult = await getPatientSearch(queryParameters);

  return jsonResult['patient_list'];
}


