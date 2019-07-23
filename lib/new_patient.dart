import 'package:flutter/material.dart';
import 'get_patient_data.dart';
import 'japiRequest.dart';
import 'irm_auth.dart';

class New_Patient extends StatefulWidget {
  @override
  _New_PatientState createState() => _New_PatientState();
}

class _New_PatientState extends State<New_Patient> {
  final TextEditingController text_vgroup_key = new TextEditingController();
  final TextEditingController text_patient_id_value =
      new TextEditingController();
  final TextEditingController text_patient_name = new TextEditingController();
  final TextEditingController text_patient_sex = new TextEditingController();
  final TextEditingController text_patient_birth_dttm =
      new TextEditingController();
  final TextEditingController text_patient_phone = new TextEditingController();
  final TextEditingController text_patient_address =
      new TextEditingController();
  final TextEditingController text_patient_guardian =
      new TextEditingController();

  void _handleSubmitted(String text) async {
    var queryParameters = {
      'vgroup_key': '${text_vgroup_key.text}',
      'patient_id_value': '${text_patient_id_value.text}',
      'patient_name': '${text_patient_name.text}',
      'patient_sex': '${text_patient_sex.text}',
      'patient_birth_dttm': '${text_patient_birth_dttm.text}',
      'patient_phone': '${text_patient_phone.text}',
      'patient_address': '${text_patient_address.text}',
      'patient_guardian': '${text_patient_guardian.text}',
    };

    var result = await postPatientCreate(queryParameters);
    print(result);

/*    var alert =
        new AlertDialog(content: new Text(result), actions: <Widget>[
      new FlatButton(
          child: const Text("Ok"),
          onPressed: () {
            Navigator.pop(context);
          })
    ]);*/

    text_vgroup_key.clear();
    text_patient_id_value.clear();
    text_patient_name.clear();
    text_patient_sex.clear();
    text_patient_birth_dttm.clear();
    text_patient_phone.clear();
    text_patient_address.clear();
    text_patient_guardian.clear();
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        controller: text_patient_id_value,
        onSubmitted: _handleSubmitted,
        decoration: new InputDecoration.collapsed(hintText: "Send a message"),
      ),
    );
  }

  ///vgroup_key
  ///patient_id_value
  ///patient_name
  ///patient_sex
  ///patient_birth_dttm
  ///patient_phone
  ///patient_address
  ///patient_guardian

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("New_Patient1"),
      ),
      body: Container(
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      controller: text_vgroup_key,
                      onSubmitted: _handleSubmitted,
                      decoration: new InputDecoration.collapsed(
                        hintText: "vgroup_key",
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ],
              ),
              new Container(
                padding: new EdgeInsets.all(10.0),
              ),
              new Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      controller: text_patient_id_value,
                      onSubmitted: _handleSubmitted,
                      decoration: new InputDecoration.collapsed(
                        hintText: "patient_id_value",
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ],
              ),
              new Container(
                padding: new EdgeInsets.all(10.0),
              ),
              new Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      controller: text_patient_name,
                      onSubmitted: _handleSubmitted,
                      decoration: new InputDecoration.collapsed(
                        hintText: "patient_name",
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ],
              ),
              new Container(
                padding: new EdgeInsets.all(10.0),
              ),
              new Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      controller: text_patient_sex,
                      onSubmitted: _handleSubmitted,
                      decoration: new InputDecoration.collapsed(
                        hintText: "patient_sex",
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ],
              ),
              new Container(
                padding: new EdgeInsets.all(10.0),
              ),
              new Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      controller: text_patient_birth_dttm,
                      onSubmitted: _handleSubmitted,
                      decoration: new InputDecoration.collapsed(
                        hintText: "patient_birth_dttm",
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ],
              ),
              new Container(
                padding: new EdgeInsets.all(10.0),
              ),
              new Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      controller: text_patient_phone,
                      onSubmitted: _handleSubmitted,
                      decoration: new InputDecoration.collapsed(
                        hintText: "patient_phone",
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ],
              ),
              new Container(
                padding: new EdgeInsets.all(10.0),
              ),
              new Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      controller: text_patient_address,
                      onSubmitted: _handleSubmitted,
                      decoration: new InputDecoration.collapsed(
                        hintText: "patient_address",
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ],
              ),
              new Container(
                padding: new EdgeInsets.all(10.0),
              ),
              new Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      controller: text_patient_guardian,
                      onSubmitted: _handleSubmitted,
                      decoration: new InputDecoration.collapsed(
                        hintText: "patient_guardian",
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () =>
                            _handleSubmitted(text_vgroup_key.text)),
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}
