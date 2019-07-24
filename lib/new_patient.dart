import 'package:flutter/material.dart';
import 'get_patient_data.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'japiRequest.dart';
import 'irm_auth.dart';

class New_Patient extends StatefulWidget {
  @override
  _New_PatientState createState() => _New_PatientState();
}

class _New_PatientState extends State<New_Patient> {
  final TextEditingController text_patient_id_value =
      new TextEditingController();
  final TextEditingController text_patient_name = new TextEditingController();
  final TextEditingController text_patient_birth_dttm =
      new TextEditingController();
  final TextEditingController text_patient_phone = new TextEditingController();
  final TextEditingController text_patient_address =
      new TextEditingController();
  final TextEditingController text_patient_guardian =
      new TextEditingController();
  String patient_sex = 'M';
  var radioValue = 0;
  var currentgroupkey = Group(patient_group["records"][0]["vgroup_key"],
      patient_group["records"][0]["vgroup_name"]);
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  List<Group> grouplist = [];
  String _currentGroup;

  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentGroup = _dropDownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    int index;
    index = 0;
    Group group;

    for (; index < patient_group['records'].length; index++) {
      group = Group(patient_group['records'][index]['vgroup_key'],
          patient_group['records'][index]['vgroup_name']);
      print(group.vgroup_name);
      print(group.vgroup_key);

      items.add(new DropdownMenuItem(
          value: group.vgroup_name, child: new Text(group.vgroup_name)));
      grouplist.add(group);
    }

    return items;
  }

  void changedDropDownItem(String selectedGroup) {
    print("Selected city $selectedGroup, we are going to refresh the UI");
    setState(() {
      _currentGroup = selectedGroup;
      currentgroupkey =
          grouplist.firstWhere(((user) => user.vgroup_name == _currentGroup));
      print(currentgroupkey.vgroup_key);
    });
  }

  Future _addPatient() async {
    var queryParameters = {
      'vgroup_key': '${currentgroupkey.vgroup_key}',
      'patient_id_value': '${text_patient_id_value.text}',
      'patient_name': '${text_patient_name.text}',
      'patient_sex': '${patient_sex}',
      'patient_birth_dttm': '${text_patient_birth_dttm.text}',
      'patient_phone': '${text_patient_phone.text}',
      'patient_address': '${text_patient_address.text}',
      'patient_guardian': '${text_patient_guardian.text}',
    };

    var result = await postPatientCreate(queryParameters);

    print(patient_sex);
    if (result == 200) {
      print('$result 성공');
    } else {
      print("$result 실패");
    }

    return result;
  }

  void handleRadioValueChange(value) {
    setState(() {
      radioValue = value;

      switch (radioValue) {
        case 0:
          patient_sex = 'M';
          break;
        case 1:
          patient_sex = 'F';
          break;
      }
    });
  }

  @override
  Widget PatientData() => DataTable(
        columns: <DataColumn>[
          DataColumn(label: Text("Property"), tooltip: "Property"),
          DataColumn(label: Text("Patient Data"), tooltip: "Patient data")
        ],
        rows: <DataRow>[
          DataRow(cells: <DataCell>[
            DataCell(Text("vgroup_key")),
            DataCell(
              DropdownButton(
                value: _currentGroup,
                items: _dropDownMenuItems,
                onChanged: changedDropDownItem,
              ),
            ),
          ]),
          DataRow(cells: <DataCell>[
            DataCell(Text("patient_id_value")),
            DataCell(
              TextFormField(
                controller: text_patient_id_value,
                decoration: new InputDecoration.collapsed(
                  hintText: "patient_id_value",
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.text,
              ),
            ),
          ]),
          DataRow(cells: <DataCell>[
            DataCell(Text("patient_name")),
            DataCell(
              TextFormField(
                controller: text_patient_name,
                decoration: new InputDecoration.collapsed(
                  hintText: "patient_name",
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.text,
              ),
            ),
          ]),
          DataRow(cells: <DataCell>[
            DataCell(Text("patient_sex")),
            DataCell(
              Row(  ///라디오 버튼 사용
                children: <Widget>[
                  Text('M'),
                  Radio(
                    value: 0,
                    groupValue: radioValue,
                    onChanged: handleRadioValueChange,
                  ),
                  Text('F'),
                  Radio(
                    value: 1,
                    groupValue: radioValue,
                    onChanged: handleRadioValueChange,
                  ),
                ],
              ),
            ),
          ]),
          DataRow(cells: <DataCell>[
            DataCell(Text("patient_birth_dttm")),
            DataCell(
              TextFormField(
                controller: text_patient_birth_dttm,
                decoration: new InputDecoration.collapsed(
                  hintText: "patient_birth_dttm",
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.text,
              ),
            ),
          ]),
          DataRow(cells: <DataCell>[
            DataCell(Text("patient_phone")),
            DataCell(
              TextFormField(
                controller: text_patient_phone,
                decoration: new InputDecoration.collapsed(
                  hintText: "patient_phone",
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.text,
              ),
            ),
          ]),
          DataRow(cells: <DataCell>[
            DataCell(Text("patient_address")),
            DataCell(
              TextFormField(
                controller: text_patient_address,
                decoration: new InputDecoration.collapsed(
                  hintText: "patient_address",
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.text,
              ),
            ),
          ]),
          DataRow(cells: <DataCell>[
            DataCell(Text("patient_guardian")),
            DataCell(
              TextFormField(
                controller: text_patient_guardian,
                decoration: new InputDecoration.collapsed(
                  hintText: "patient_guardian",
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.text,
              ),
            ),
          ]),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(title: new Text("New Patient"), actions: <Widget>[
        new FlatButton(
            child: new Text(
              "Add",
              style: new TextStyle(fontSize: 16, color: Colors.white),
            ),
            onPressed: () async {
              var result = await _addPatient();
              var alert = AlertDialog(
                  content: new Text(result.toString()),
                  actions: <Widget>[
                    new FlatButton(
                        child: const Text("Ok"),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ]);
              showDialog(
                  context: context, builder: (BuildContext context) => alert);
            })
      ]),
      body: Container(
          child: Center(
        child: new Column(
          children: <Widget>[
            PatientData(),
          ],
        ),
      )),
    );
  }
}
