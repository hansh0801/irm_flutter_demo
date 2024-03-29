import 'package:flutter/material.dart';
import 'irm_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'get_patient_data.dart';
import 'patients_info_detailpage.dart';

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types

List<DropdownMenuItem<String>> _dropDownMenuItems;
String _currentGroup;
List<Group> grouplist = [];

final TextEditingController _textEditingController =
    new TextEditingController();

Stream<List<Patientlist>> _getPatientList(int currentgroupkey) async* {
  var jsondata = await getPatientList(currentgroupkey);

  print("start $jsondata");
  List<Patientlist> PatientLists = [];

  for (var u in jsondata) {
    Patientlist patientlist = Patientlist(
        u["vgroup_key"],
        u['patient_key'],
        u['patient_id_value'],
        u['patient_name'],
        u['patient_sex'],
        u['patient_address'],
        u['patient_birth_dttm'],
        u['patient_guardian'],
        u['patient_phone']);

    PatientLists.add(patientlist);
  }

  print(PatientLists.length);

  yield PatientLists;
}

class Patients_Info extends StatefulWidget {
  @override
  _Patients_InfoState createState() => _Patients_InfoState();
}

class _Patients_InfoState extends State<Patients_Info> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: new AppBar(
          title: Text("Patient info"),
        ),
        body: Container(
          child: PatientInfoHomePage(),
        ));
  }
}

class PatientInfoHomePage extends StatefulWidget {
  @override
  _PatientInfoHomePageState createState() => _PatientInfoHomePageState();
}

class _PatientInfoHomePageState extends State<PatientInfoHomePage> {
  bool notSearched = true;
  String searchText;

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
    setState(() {
      _currentGroup = selectedGroup;
      currentgroupkey =
          grouplist.firstWhere(((user) => user.vgroup_name == _currentGroup));
      print(currentgroupkey.vgroup_key);
      notSearched = true;
    });
  }

  void _handleSubmitted(String text) {
    setState(() {
      searchText = text;
      notSearched = false;

      _textEditingController.clear();
    });
  }

  Stream searchList() async* {
    var searchList =
        await searchPatientName(currentgroupkey.vgroup_key, searchText);
    List<Patientlist> result = [];
    for (var u in searchList) {
      Patientlist patientlist = Patientlist(
          u["vgroup_key"],
          u['patient_key'],
          u['patient_id_value'],
          u['patient_name'],
          u['patient_sex'],
          u['patient_address'],
          u['patient_birth_dttm'],
          u['patient_guardian'],
          u['patient_phone']);

      result.add(patientlist);
    }
    print(result.length);

    yield result;
  }

  int calculateAge(String birthString) {
    if (birthString == null) return 0;
    DateTime birthDate = DateTime.parse(birthString); //스트링을 알아서 변환해줌
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }

    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Column(children: [
        new Container(
          padding: new EdgeInsets.all(10.0),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0), border: Border.all()),
          child: new DropdownButton(
            value: _currentGroup,
            items: _dropDownMenuItems,
            onChanged: changedDropDownItem,
          ),
        ),
        new Row(
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _textEditingController,
                  onSubmitted: _handleSubmitted,
                  decoration: new InputDecoration(
                      labelText: "search",
                      hintText: "검색할 환자를 입력하세요",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      )),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                ),
              ),
            ),
            Container(
              padding: new EdgeInsets.all(8.0),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () =>
                      _handleSubmitted(_textEditingController.text)),
            ),
          ],
        ),
        Expanded(
          child: SizedBox(
            height: 200.0,
            child: StreamBuilder(
                stream: notSearched
                    ? _getPatientList(currentgroupkey.vgroup_key)
                    : searchList(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Container(
                        child: SpinKitPouringHourglass(
                      color: Colors.lightBlueAccent,
                      size: 50,
                    ));
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 8.0,
                            margin: new EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                            child: Container(
                              decoration: BoxDecoration(),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                leading: Container(
                                  padding: EdgeInsets.only(right: 15.0),
                                  decoration: new BoxDecoration(
                                      border: new Border(
                                          right: new BorderSide(
                                              width: 1.0,
                                              color: Colors.black26))),
                                  child: new CircleAvatar(
                                    backgroundColor: getColor(snapshot
                                        .data[index].patient_sex
                                        .toString()),
                                    child: new Text(snapshot
                                        .data[index].patient_sex
                                        .toString()),
                                  ),
                                ),
                                title: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Flexible(
                                        child: Text(snapshot
                                            .data[index].patient_name
                                            .toString())),
                                    Text(snapshot.data[index].patient_sex
                                            .toString() +
                                        ' / ' +
                                        calculateAge(snapshot
                                                .data[index].patient_birth_dttm)
                                            .toString())
                                  ],
                                ),
                                subtitle: Text(snapshot
                                    .data[index].patient_id_value
                                    .toString()),
                                trailing: Icon(Icons.keyboard_arrow_right,
                                    color: Colors.black26, size: 30.0),
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailPage(
                                              patientinfo: snapshot.data[index],
                                              groupName:
                                                  currentgroupkey.vgroup_name,
                                            ))),
                              ),
                            ),
                          );
                        });
                  }
                }),
          ),
        )
      ]),
    );
  }
}

Color getColor(String patientsex) {
  if (patientsex == "M" || patientsex == "m") {
    return Colors.blueAccent;
  } else if (patientsex == "F" || patientsex == "f") {
    return Colors.redAccent;
  } else if (patientsex == "O" || patientsex == "o") {
    return Colors.amberAccent;
  } else
    return Colors.white10;
}
